import std.stdio;

import cell;
import sim_state;

const double VISCOSITY = 1.01;
const double VISCOSITY_SLOWING_FACTOR = 1 / VISCOSITY;

void update(SimulationState *state) {
	auto FIELD_RAD = state.FIELD_RAD;

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
}
