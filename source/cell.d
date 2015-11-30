import gfm.math.vector;

import render;
import render_state;

class Cell {
	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double rad;

	this(double x, double y) {
		pos = Vector!(double, 2)(x, y);
		vel = Vector!(double, 2)(-1, -1);
		rad = 5;
	}

	void render(RenderState *state) {
		state.drawRect(
			pos - Vector!(double, 2)(rad / 2, rad / 2),
			Vector!(double, 2)(rad, rad)
		);
	}
};
