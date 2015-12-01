import std.math;
import std.random;
import gfm.math.vector;

import render;
import render_state;

const double RAD_PER_FOOD = 0.5;
const double BASE_RAD = 2;

class Cell {
	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double foodLevel = 8;
	double reproductionThreshold = 6;

	this(double x, double y) {
		this(Vector!(double, 2)(x, y));
	}

	this(Vector!(double, 2) pos) {
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

	double rad() {
		return BASE_RAD + foodLevel * RAD_PER_FOOD;
	}

	double foodConsumption() {
		return 0.01;
	}
};
