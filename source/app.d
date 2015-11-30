import std.stdio;
import derelict.sdl2.sdl;

import state;
import render;
import update;
import event_handler;

void main() {
	State state = new State();
	if (!initRenderer(&state.renderState)) {
		writeln("an error occurred initializing the renderer");
	}

	while (state.simState.running) {
		// handle event queue
		SDL_Event event;
		while (SDL_PollEvent(&event) != 0) {
			handleEvent(&state, event);
		}

		update.update(&state.simState);
		render.render(&state);
	}

	cleanupRenderer(&state.renderState);
}
