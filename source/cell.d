import std.math;
import std.random;
import gfm.math.vector;

import render;
import render_state;

class Cell {
	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double rad;

	this(double x, double y) {
		pos = Vector!(double, 2)(x, y);

		auto velAngle = uniform(0, 2 * PI);
		vel = Vector!(double, 2)(cos(velAngle), sin(velAngle));
		rad = 5;
	}

	void render(RenderState *state) {
		state.drawRect(
			pos - Vector!(double, 2)(rad / 2, rad / 2),
			Vector!(double, 2)(rad, rad)
		);
	}
};
