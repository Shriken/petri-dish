module state.sim_state;

import std.math;
import std.path;
import std.random;
import derelict.sdl2.sdl;

import consts;
import genome;
import actor.cell;
import actor.food;

class SimulationState {
	bool running = true;
	const double FIELD_RAD = 320;
	Genome genome;
	Cell[] cells;
	Food[] food;

	double foodGenRate = 5;
	double foodGenStatus = 0;

	this() {
		genome = Genome.load(
			buildNormalizedPath(RES_PATH, "genomes/simple-swimmers.gnm")
		);

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
