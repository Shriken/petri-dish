import std.stdio;
import derelict.sdl2.sdl;

import render;
import render_state;
import event_handler;

void main() {
	RenderState state = new RenderState();
	if (!initRenderer(&state)) {
		writeln("an error occurred initializing the renderer");
	}

	while (state.running) {
		// handle event queue
		SDL_Event event;
		while (SDL_PollEvent(&event) != 0) {
			handleEvent(&state, event);
		}
	}

	cleanup(&state);
}
