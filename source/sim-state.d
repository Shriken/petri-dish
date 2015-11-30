module sim_state;

import std.random;

import cell;
import food;

class SimulationState {
	bool running = true;
	const double FIELD_RAD = 320;
	Cell[] cells;
	Food[] food;

	double foodGenProb = 0.5;

	this() {
		foreach (int i; 0 .. 50) {
			auto x = uniform(-FIELD_RAD, FIELD_RAD);
			auto y = uniform(-FIELD_RAD, FIELD_RAD);
			cells ~= new Cell(x, y);
		}
	}
};
