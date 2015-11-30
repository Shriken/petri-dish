import gfm.math.vector;

import render;
import render_state;

class Cell {
	Vector!(double, 2) pos;
	Vector!(double, 2) vel;
	double rad;

	this() {
		pos = Vector!(double, 2)(0, 100);
		vel = Vector!(double, 2)(-0.3, -0.3);
		rad = 5;
	}

	void render(RenderState *state) {
		state.drawRect(
			pos - Vector!(double, 2)(rad / 2, rad / 2),
			Vector!(double, 2)(rad, rad)
		);
	}
};
