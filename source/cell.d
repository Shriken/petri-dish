import std.math;
import std.random;
import gfm.math.vector;

import genome;
import render;
import render_state;

const double RAD_PER_FOOD = 0.5;
const double BASE_RAD = 2;

class Cell {
	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double foodLevel = 8;
	double angle = 0;
	CellMode *mode;
	Genome genome;

	@disable this();

	this(Cell cell) {
		this.pos = cell.pos;
		this.vel = cell.vel;
		this.foodLevel = cell.foodLevel;
		this.angle = cell.angle;
		this.mode = cell.mode;
		this.genome = cell.genome;
	}

	this(double x, double y, Genome genome, CellMode *mode) {
		this(Vector!(double, 2)(x, y), genome, mode);
	}

	this(Vector!(double, 2) pos, Genome genome, CellMode *mode) {
		this.genome = genome;
		this.mode = mode;
		this.pos = pos;

		auto velAngle = uniform(0, 2 * PI);
		vel = Vector!(double, 2)(cos(velAngle), sin(velAngle));
	}

	void render(RenderState *state) {
		auto rad = this.rad;
		state.drawRect(
			pos - Vector!(double, 2)(rad, rad),
			Vector!(double, 2)(rad * 2, rad * 2),
			0xff, 0, 0, 0xff
		);
	}

	Cell reproduce() {
		foodLevel /= 2;

		Cell newCell = new Cell(this);
		newCell.vel.x += cos(angle + mode.splitAngle);
		newCell.vel.y += sin(angle + mode.splitAngle);
		newCell.angle = (angle + mode.splitAngle + mode.child2Rotation)
			% 2 * PI;
		newCell.mode = &genome.cellModes[mode.child2Mode];

		vel.x -= cos(angle + mode.splitAngle);
		vel.y -= sin(angle + mode.splitAngle);
		angle = (angle + mode.splitAngle + mode.child1Rotation) % 2 * PI;
		mode = &genome.cellModes[mode.child1Mode];

		return newCell;
	}

	double rad() {
		return BASE_RAD + foodLevel * RAD_PER_FOOD;
	}

	double foodConsumption() {
		return 0.01;
	}
};
