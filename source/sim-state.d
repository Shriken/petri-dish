module sim_state;

import std.random;

import cell;

class SimulationState {
	bool running = true;
	const double FIELD_RAD = 320;
	Cell[] cells;

	this() {
		foreach (int i; 0 .. 50) {
			auto x = uniform(-FIELD_RAD, FIELD_RAD);
			auto y = uniform(-FIELD_RAD, FIELD_RAD);
			cells ~= new Cell(x, y);
		}
	}
};
