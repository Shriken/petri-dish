import std.math;
import std.stdio;
import std.random;
import std.algorithm;
import std.parallelism;

import consts;
import genome;
import state.sim_state;
import actor.cell;
import actor.food;

void update(SimulationState state) {
	auto FIELD_RAD = state.FIELD_RAD;

	// update cell positions
	foreach (ref Cell cell; parallel(state.cells)) {
		cell.updatePos();
		constrainPos(state, cell);
	}

	Cell[] newCells;
	foreach (ref Cell cell; parallel(state.cells)) {
		// handle collisions
		foreach (ref Cell otherCell; state.cells) {
			// don't collide with yourself
			if (cell !is otherCell) {
				cell.collide(otherCell);
			}
		}

		// handle cell's special ability
		handleSpecialAbility(state, cell);

		if (cell.mass <= Cell.MIN_MASS) {
			// starve
			cell.shouldDie = true;
		} else if (cell.mass >= cell.mode.splitThreshold) {
			// reproduce
			synchronized {
				newCells ~= cell.reproduce();
			}
		}

		// consume mass through existence
		cell.massChange -= cell.massConsumption();

		// move mass around between adhesed cells
		foreach (ref Cell adhesedCell; cell.adhesedCells) {
			auto deltaMass = adhesedCell.mass - cell.mass;
			deltaMass = min(MASS_FLOW_RATE, deltaMass);
			deltaMass = max(-MASS_FLOW_RATE, deltaMass);
			cell.massChange += deltaMass;
		}
	}

	foreach (cell; parallel(state.cells)) {
		// update mass
		cell.gainMass(cell.massChange);
		cell.massChange = 0;
	}

	state.cells ~= newCells;

	// clean up dead food and cells
	for (int i = 0; i < state.food.length; i++) {
		auto food = state.food[i];
		if (food.shouldDie || food.age++ >= Food.MAX_AGE) {
			state.food = state.food.remove!(SwapStrategy.unstable)(i--);
		}
	}
	for (int i = 0; i < state.cells.length; i++) {
		if (state.cells[i].shouldDie) {
			state.cells[i].die();
			state.cells = state.cells.remove!(SwapStrategy.unstable)(i--);
		}
	}

	// generate new food
	state.foodGenStatus += state.foodGenRate;
	while (state.foodGenStatus > 1) {
		auto x = uniform(-FIELD_RAD, FIELD_RAD);
		auto y = uniform(-FIELD_RAD, FIELD_RAD);
		state.food ~= new Food(x, y);
		state.foodGenStatus--;
	}
}

void constrainPos(SimulationState state, Cell cell) {
	auto FIELD_RAD = state.FIELD_RAD;
	auto pos = &cell.pos;

	// constrain cell to field bounds
	if (pos.x < -FIELD_RAD) {
		pos.x = -pos.x - 2 * FIELD_RAD;
		cell.vel.x *= -1;
	} else if (pos.x > FIELD_RAD) {
		pos.x = 2 * FIELD_RAD - pos.x;
		cell.vel.x *= -1;
	}

	if (pos.y < -FIELD_RAD) {
		pos.y = -pos.y - 2 * FIELD_RAD;
		cell.vel.y *= -1;
	} else if (pos.y > FIELD_RAD) {
		pos.y = 2 * FIELD_RAD - pos.y;
		cell.vel.y *= -1;
	}
}

void handleSpecialAbility(SimulationState state, Cell cell) {
	final switch (cell.mode.cellType) {
		case CellType.phagocyte:
			// consume nearby food
			foreach (food; state.food) {
				auto posDiff = cell.pos - food.pos;
				auto radSum = cell.rad + food.rad;
				if (posDiff.squaredLength() < radSum ^^ 2) {
					cell.massChange += food.amount;
					food.shouldDie = true;
				}
			}
			break;

		case CellType.flagellocyte:
			cell.vel.x += FLAGELLOCYTE_ACCELERATION * cos(cell.heading);
			cell.vel.y += FLAGELLOCYTE_ACCELERATION * sin(cell.heading);
			break;

		case CellType.photocyte:
			break;

		case CellType.devorocyte:
			// consume nearby cells
			// functionality in Cell.collide()
			break;

		case CellType.lipocyte:
			break;
		case CellType.keratinocyte:
			break;
		case CellType.buoyocyte:
			break;
		case CellType.glueocyte:
			break;
		case CellType.virocyte:
			break;
		case CellType.nitrocyte:
			break;
	}
}
