module sim_state;

import std.random;

import cell;
import food;
import genome;

class SimulationState {
	bool running = true;
	const double FIELD_RAD = 320;
	Genome genome;
	Cell[] cells;
	Food[] food;

	double foodGenProb = 0.5;

	this() {
		genome = new Genome();

		foreach (int i; 0 .. 50) {
			auto x = uniform(-FIELD_RAD, FIELD_RAD);
			auto y = uniform(-FIELD_RAD, FIELD_RAD);
			cells ~= new Cell(x, y, &genome.cellModes[0]);
		}
	}
};
