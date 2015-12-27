module state.sim_state;

import std.math;
import std.random;
import derelict.sdl2.sdl;

import genome;
import misc.resources;
import actor.cell;
import actor.food;

class SimulationState {
	bool running = true;
	bool paused = false;
	const double FIELD_RAD = 320;
	Genome[] genomes;
	size_t curGenomeIndex = 0;
	Cell[] cells;
	Food[] food;

	double foodGenRate = 5;
	double foodGenStatus = 0;

	this() {
		genomes ~= Genome.load(
			getResourcePath("genomes/simple-swimmers.gnm")
		);
		genomes ~= new Genome();
		genomes[$ - 1].cellModes[0].cellType = CellType.devorocyte;

		// spawn starter cells
		foreach (int i; 0 .. 50) {
			auto x = uniform(-FIELD_RAD, FIELD_RAD);
			auto y = uniform(-FIELD_RAD, FIELD_RAD);
			addCell(x, y);
		}
	}

	void addCell(double x, double y) {
		auto genome = genomes[curGenomeIndex];
		cells ~= new Cell(x, y, genome, &genome.cellModes[0]);
	}
};
