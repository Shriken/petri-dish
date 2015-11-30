import std.stdio;
import std.random;
import std.algorithm;

import cell;
import food;
import sim_state;

const double VISCOSITY = 1.01;
const double VISCOSITY_SLOWING_FACTOR = 1 / VISCOSITY;

void update(SimulationState *state) {
	auto FIELD_RAD = state.FIELD_RAD;

	// update cell positions
	foreach (ref Cell cell; state.cells) {
		auto pos = &cell.pos;

		// update position
		cell.pos += cell.vel;

		// simulate viscosity
		cell.vel *= VISCOSITY_SLOWING_FACTOR;

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

	// TODO check for collision

	// check for food consumption
	foreach (ref Cell cell; state.cells) {
		foreach (i, food; state.food) {
			auto posDiff = cell.pos - food.pos;
			auto radSum = cell.rad + food.rad;
			if (posDiff.squaredLength() < radSum ^^ 2) {
				cell.foodLevel += food.amount;
				food.shouldDie = true;
			}
		}
	}

	for (int i = 0; i < state.food.length; i++) {
		if (state.food[i].shouldDie) {
			state.food.remove(i--);
			state.food.length--;
		}
	}

	// generate new food
	if (uniform(0., 1.) < state.foodGenProb) {
		auto x = uniform(-FIELD_RAD, FIELD_RAD);
		auto y = uniform(-FIELD_RAD, FIELD_RAD);
		state.food ~= new Food(x, y);
	}
}
