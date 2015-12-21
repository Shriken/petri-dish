module widget.widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import state.state;

abstract class Widget {
	vec2i offset;
	vec2i dimensions;
	int height = 0;

	this(vec2i offset, vec2i dimensions) {
		this.offset = offset;
		this.dimensions = dimensions;
	}

	void render(State state);
	void handleClick(State state, SDL_MouseButtonEvent event);
}
