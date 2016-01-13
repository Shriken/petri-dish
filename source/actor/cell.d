module actor.cell;

import std.math;
import std.range;
import std.stdio;
import std.random;
import std.algorithm;
import gfm.math.vector;
import derelict.sdl2.sdl;

import consts;
import genome;
import misc.coords;
import state.render_state;
import widget.experiment_render_utils;

class Cell {
	static const double RAD_PER_MASS = 2;
	static const double MIN_MASS = 0.65;
	static const double MAX_MASS = 3.55;
	static const double DEVOROCYTE_CONSUMPTION_RATE = 0.3;

	WorldCoords pos;
	WorldCoords vel;
	double mass = 2;
	double heading = 0;
	CellMode *mode;
	Genome genome;

	Cell[] adhesedCells;

	// state variables for use in update
	bool shouldDie = false;
	double massChange = 0;
	double headingChange = 0;

	@disable this();

	this(Cell cell) {
		this.pos = cell.pos;
		this.vel = cell.vel;
		this.mass = cell.mass;
		this.heading = cell.heading;
		this.mode = cell.mode;
		this.genome = cell.genome;
		this.adhesedCells = cell.adhesedCells.dup;
	}

	this(WorldCoords pos, Genome genome, CellMode *mode) {
		this.genome = genome;
		this.mode = mode;
		this.pos = pos;
		this.vel = WorldCoords(0, 0);
		this.heading = uniform(0, 2 * PI);
	}

	void render(ref ExperimentRenderState state) {
		state.fillRect(
			pos - WorldCoords(rad, rad),
			WorldCoords(rad * 2, rad * 2),
			mode.color,
			0xff
		);

		// draw adhesin bonds
		foreach (cell; adhesedCells) {
			state.drawLine(
				pos,
				cell.pos,
				SDL_Color(0xff, 0xff, 0xff),
				0xff
			);
		}
	}

	Cell reproduce() {
		auto oldMode = mode;
		massChange -= mass / 2;

		// child 2
		Cell newCell = new Cell(this);
		newCell.vel.x -= cos(heading + oldMode.splitAngle);
		newCell.vel.y -= sin(heading + oldMode.splitAngle);
		newCell.heading = (
			heading + oldMode.splitAngle + oldMode.child2Rotation
		) % 2 * PI;
		newCell.mode = &genome.cellModes[oldMode.child2Mode];
		newCell.mass /= 2;

		if (oldMode.child2KeepAdhesin) {
			foreach (cell; newCell.adhesedCells) {
				assert(!cell.isBoundTo(newCell));
				cell.adheseWith(newCell);
			}
		} else {
			foreach (cell; newCell.adhesedCells) {
				assert(!cell.isBoundTo(newCell));
			}
			newCell.adhesedCells.destroy();
		}

		// child 1
		vel.x += cos(heading + oldMode.splitAngle);
		vel.y += sin(heading + oldMode.splitAngle);
		heading = (
			heading + oldMode.splitAngle + oldMode.child1Rotation
		) % 2 * PI;
		mode = &genome.cellModes[oldMode.child1Mode];
		if (!oldMode.child1KeepAdhesin) {
			foreach (cell; adhesedCells) {
				cell.unadheseWith(this);
				assert(!cell.isBoundTo(this));
			}
			adhesedCells.destroy();
		}

		if (oldMode.makeAdhesin) {
			this.adheseWith(newCell);
			newCell.adheseWith(this);
		}

		return newCell;
	}

	void die() {
		foreach (cell; adhesedCells) {
			cell.unadheseWith(this);
		}
		adhesedCells.destroy();
	}

	void gainMass(double amount) {
		mass += amount;
		if (mass > Cell.MAX_MASS) {
			mass = Cell.MAX_MASS;
		}
	}

	double rad() {
		return mass * Cell.RAD_PER_MASS;
	}

	double massConsumption() {
		if (mode.cellType is CellType.flagellocyte) {
			return 0.003;
		}

		return 0.002;
	}

	void collide(Cell otherCell) {
		// check and handle actual collisions
		auto posDiff = pos - otherCell.pos;
		auto radSum = rad + otherCell.rad;
		auto diffSquared = posDiff.squaredLength();
		if (diffSquared < radSum ^^ 2) {
			vel += posDiff / diffSquared;

			if (
				mode.cellType is CellType.devorocyte &&
				otherCell.mode.cellType !is CellType.devorocyte
			) {
				// eat other cell
				massChange += DEVOROCYTE_CONSUMPTION_RATE;
				otherCell.massChange -= DEVOROCYTE_CONSUMPTION_RATE;
			}
		}
	}
};

void updatePos(Cell cell) {
	// update position
	cell.pos += cell.vel;

	// simulate viscosity
	cell.vel *= VISCOSITY_SLOWING_FACTOR;

	foreach (adhesedCell; cell.adhesedCells) {
		auto posDiff = adhesedCell.pos - cell.pos;
		auto radSum = cell.rad + adhesedCell.rad;
		auto squaredDist = posDiff.squaredLength;
		if (squaredDist > radSum ^^ 2) {
			cell.vel += posDiff * 0.03;
		}
	}
}

void adheseWith(Cell cell, Cell otherCell) {
	cell.adhesedCells ~= otherCell;
}

void unadheseWith(Cell cell, Cell otherCell) {
	auto index = cell.adhesedCells.countUntil(otherCell);
	cell.adhesedCells = cell.adhesedCells.remove!(SwapStrategy.unstable)(
		index
	);
}

bool isBoundTo(Cell cell, Cell otherCell) {
	return any!(cell => cell is otherCell)(cell.adhesedCells);
}
