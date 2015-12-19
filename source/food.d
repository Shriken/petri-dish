import gfm.math.vector;
import derelict.sdl2.sdl;

import render;
import render_state;

class Food {
	static const int MAX_AGE = 60 * 10;
	static double rad = 1;
	static double amount = 0.8;

	Vector!(double, 2) pos;
	bool shouldDie = false;
	int age = 0;

	this(double x, double y) {
		pos = Vector!(double, 2)(x, y);
	}

	void render(RenderState state) {
		state.drawRect(
			pos - Vector!(double, 2)(rad, rad),
			Vector!(double, 2)(rad * 2, rad * 2),
			SDL_Color(0x96, 0x4b, 0x00),
			0xff
		);
	}
};
