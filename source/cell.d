import std.math;
import std.random;
import gfm.math.vector;

import genome;
import render;
import render_state;

class Cell {
	static const double RAD_PER_MASS = 2;
	static const double MIN_MASS = 0.65;
	static const double MAX_MASS = 3.55;

	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double mass = 2;
	double angle = 0;
	CellMode *mode;
	Genome genome;

	Cell[] adhesedCells;

	bool shouldDie = false;

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

	void render(RenderState *state) {
		auto rad = this.rad;
		state.drawRect(
			pos - Vector!(double, 2)(rad, rad),
			Vector!(double, 2)(rad * 2, rad * 2),
			mode.color.r, mode.color.g, mode.color.b, 0xff
		);
	}

	Cell reproduce() {
		mass /= 2;

		// child 2
		Cell newCell = new Cell(this);
		newCell.vel.x -= cos(angle + mode.splitAngle);
		newCell.vel.y -= sin(angle + mode.splitAngle);
		newCell.angle = (angle + mode.splitAngle + mode.child2Rotation)
			% 2 * PI;
		newCell.mode = &genome.cellModes[mode.child2Mode];
		if (!mode.child2KeepAdhesin) {
			newCell.adhesedCells.destroy();
		}

		// child 1
		vel.x += cos(angle + mode.splitAngle);
		vel.y += sin(angle + mode.splitAngle);
		angle = (angle + mode.splitAngle + mode.child1Rotation) % 2 * PI;
		mode = &genome.cellModes[mode.child1Mode];
		if (!mode.child1KeepAdhesin) {
			adhesedCells.destroy();
		}

		if (mode.makeAdhesin) {
			adhesedCells ~= newCell;
			newCell.adhesedCells ~= this;
		}

		return newCell;
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
};
