import std.stdio;

import sim_state;

const double VISCOSITY = 1.0001;

void update(SimulationState *state) {
	auto cell = &state.cell;
	cell.pos += cell.vel;

	auto pos = &cell.pos;
	auto FIELD_RAD = state.FIELD_RAD;

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

	cell.vel /= VISCOSITY;
}
