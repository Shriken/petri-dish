module actor.food;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.coords;
import state.render_state;

class Food {
	static const int MAX_AGE = 60 * 10;
	static double rad = 1;
	static double amount = 0.8;

	WorldCoords pos;
	bool shouldDie = false;
	int age = 0;

	this(double x, double y) {
		pos = WorldCoords(x, y);
	}

	void render(RenderState state) {
		state.drawRectWorldCoords(
			pos - WorldCoords(rad, rad),
			WorldCoords(rad * 2, rad * 2),
			SDL_Color(0x96, 0x4b, 0x00),
			0xff
		);
	}
};
