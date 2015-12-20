module widget.widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import state.state;

abstract class Widget {
	vec2i offset;
	vec2i dimensions;

	void render(State state);
	void handleEvent(SDL_Event event);
}
