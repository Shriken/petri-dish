import std.math;
import std.stdio;
import std.random;
import std.algorithm;
import std.parallelism;

import cell;
import food;
import genome;
import sim_state;

const double VISCOSITY = 1.1;
const double VISCOSITY_SLOWING_FACTOR = 1 / VISCOSITY;

// rate of mass flow through adhesin
const double MASS_FLOW_RATE = 0.04;

void update(SimulationState state) {
	auto FIELD_RAD = state.FIELD_RAD;

	// update cell positions
	foreach (ref Cell cell; state.cells) {
		updatePos(state, cell);
	}

	Cell[] newCells;
	foreach (ref Cell cell; parallel(state.cells)) {
		// handle collisions
		foreach (ref Cell otherCell; state.cells) {
			// don't collide with yourself
			if (&cell == &otherCell) {
				continue;
			}

			auto posDiff = cell.pos - otherCell.pos;
			auto radSum = cell.rad + otherCell.rad;
			auto diffSquared = posDiff.squaredLength();
			if (diffSquared < radSum ^^ 2) {
				cell.vel += posDiff / diffSquared;
			}
		}

		// handle cell's special ability
		handleSpecialAbility(state, cell);

		if (cell.mass <= Cell.MIN_MASS) {
			// starve
			cell.shouldDie = true;
		} else if (cell.mass >= cell.mode.splitThreshold) {
			// reproduce
			newCells ~= cell.reproduce();
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
		cell.mass += cell.massChange;
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

void updatePos(SimulationState state, ref Cell cell) {
	auto FIELD_RAD = state.FIELD_RAD;
	auto pos = &cell.pos;

	// update position
	cell.pos += cell.vel;

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

	// simulate viscosity
	cell.vel *= VISCOSITY_SLOWING_FACTOR;

	foreach (adhesedCell; cell.adhesedCells) {
		auto posDiff = adhesedCell.pos - cell.pos;
		auto radSum = cell.rad + adhesedCell.rad;
		auto squaredDist = posDiff.squaredLength;
		if (squaredDist > radSum ^^ 2) {
			cell.vel += posDiff * 0.03;
		}
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
			cell.vel.x += 0.1 * cos(cell.angle);
			cell.vel.y += 0.1 * sin(cell.angle);
			break;

		case CellType.photocyte:
			break;
		case CellType.devorocyte:
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
