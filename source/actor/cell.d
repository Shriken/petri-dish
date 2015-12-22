module actor.cell;

import std.math;
import std.range;
import std.stdio;
import std.random;
import std.algorithm;
import gfm.math.vector;
import derelict.sdl2.sdl;

import genome;
import render_utils;
import state.render_state;

class Cell {
	static const double RAD_PER_MASS = 2;
	static const double MIN_MASS = 0.65;
	static const double MAX_MASS = 3.55;
	static const double DEVOROCYTE_CONSUMPTION_RATE = 0.3;

	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double mass = 2;
	double angle = 0;
	CellMode *mode;
	Genome genome;

	Cell[] adhesedCells;

	// state variables for use in update
	bool shouldDie = false;
	double massChange = 0;

	@disable this();

	this(Cell cell) {
		this.pos = cell.pos;
		this.vel = cell.vel;
		this.mass = cell.mass;
		this.angle = cell.angle;
		this.mode = cell.mode;
		this.genome = cell.genome;
		this.adhesedCells = cell.adhesedCells.dup;
	}

	this(double x, double y, Genome genome, CellMode *mode) {
		this(Vector!(double, 2)(x, y), genome, mode);
	}

	this(Vector!(double, 2) pos, Genome genome, CellMode *mode) {
		this.genome = genome;
		this.mode = mode;
		this.pos = pos;
		this.vel = Vector!(double, 2)(0, 0);
		this.angle = uniform(0, 2 * PI);
	}

	void render(RenderState state) {
		auto rad = this.rad;
		state.drawRectWorldCoords(
			pos - Vector!(double, 2)(rad, rad),
			Vector!(double, 2)(rad * 2, rad * 2),
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
		massChange -= mass / 2;

		auto oldMode = mode;

		// child 2
		Cell newCell = new Cell(this);
		newCell.vel.x -= cos(angle + oldMode.splitAngle);
		newCell.vel.y -= sin(angle + oldMode.splitAngle);
		newCell.angle = (
			angle + oldMode.splitAngle + oldMode.child2Rotation
		) % 2 * PI;
		newCell.mode = &genome.cellModes[oldMode.child2Mode];
		newCell.mass /= 2;

		if (oldMode.child2KeepAdhesin) {
			foreach (cell; newCell.adhesedCells) {
				assert(cell.adhesedCells.find(newCell).empty);
				cell.adhesedCells ~= newCell;
			}
		} else {
			foreach (cell; newCell.adhesedCells) {
				assert(cell.adhesedCells.find(newCell).empty);
			}
			newCell.adhesedCells.destroy();
		}

		// child 1
		vel.x += cos(angle + oldMode.splitAngle);
		vel.y += sin(angle + oldMode.splitAngle);
		angle = (
			angle + oldMode.splitAngle + oldMode.child1Rotation
		) % 2 * PI;
		mode = &genome.cellModes[oldMode.child1Mode];
		if (!oldMode.child1KeepAdhesin) {
			foreach (cell; adhesedCells) {
				cell.unadheseWith(this);
				assert(cell.adhesedCells.find(this).empty);
			}
			adhesedCells.destroy();
		}

		if (oldMode.makeAdhesin) {
			adhesedCells ~= newCell;
			newCell.adhesedCells ~= this;
		}

		return newCell;
	}

	void die() {
		foreach (cell; adhesedCells) {
			cell.unadheseWith(this);
		}
		adhesedCells.destroy();
	}

	void unadheseWith(Cell cell) {
		auto index = adhesedCells.countUntil(cell);
		adhesedCells = adhesedCells.remove!(SwapStrategy.unstable)(index);
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
		return 0.003;
	}

	void collide(Cell otherCell) {
		// check and handle actual collisions
		auto posDiff = pos - otherCell.pos;
		auto radSum = rad + otherCell.rad;
		auto diffSquared = posDiff.squaredLength();
		if (diffSquared < radSum ^^ 2) {
			vel += posDiff / diffSquared;
		}

		if (mode.cellType is CellType.devorocyte) {
			// eat other cell
			massChange += DEVOROCYTE_CONSUMPTION_RATE;
			otherCell.massChange -= DEVOROCYTE_CONSUMPTION_RATE;
		}
	}
};
