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

	double foodGenRate = 5;
	double foodGenStatus = 0;

	this() {
		genome = new Genome();
		genome.cellModes[0].makeAdhesin = true;
		genome.cellModes[0].child1Mode = 1;
		genome.cellModes[0].child2Mode = 2;

		genome.cellModes[1].splitAngle = PI / 2;
		genome.cellModes[1].child1Mode = 0;
		genome.cellModes[1].child1KeepAdhesin = false;

		genome.cellModes[2].cellType = CellType.flagellocyte;

		// spawn starter cells
		foreach (int i; 0 .. 50) {
			auto x = uniform(-FIELD_RAD, FIELD_RAD);
			auto y = uniform(-FIELD_RAD, FIELD_RAD);
			addCell(x, y);
		}
	}

	void addCell(double x, double y) {
		cells ~= new Cell(x, y, genome, &genome.cellModes[0]);
	}
};
