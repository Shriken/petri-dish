import gfm.math.vector;

import render;
import render_state;

class Food {
	static double rad = 1;
	static double amount = 1;

	Vector!(double, 2) pos;
	bool shouldDie = false;

	this(double x, double y) {
		pos = Vector!(double, 2)(x, y);
	}

	void render(RenderState *state) {
		state.drawRect(
			pos - Vector!(double, 2)(rad, rad),
			Vector!(double, 2)(rad * 2, rad * 2),
			0x96, 0x4b, 0x00, 0xff
		);
	}
};
