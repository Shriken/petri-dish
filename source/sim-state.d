module sim_state;

import std.random;
import std.math;

import cell;
import food;
import genome;

class SimulationState {
	bool running = true;
	const double FIELD_RAD = 320;
	Genome genome;
	Cell[] cells;
	Food[] food;

	double foodGenRate = 4;
	double foodGenStatus = 0;

	this() {
		genome = new Genome();
		genome.cellModes[0].splitAngle = PI / 2;

		// spawn starter cells
		foreach (int i; 0 .. 50) {
			auto x = uniform(0, 2 * FIELD_RAD);
			auto y = uniform(0, 2 * FIELD_RAD);
			addCell(x, y);
		}
	}

	void addCell(double x, double y) {
		x -= FIELD_RAD;
		y -= FIELD_RAD;
		cells ~= new Cell(x, y, genome, &genome.cellModes[0]);
	}
};
