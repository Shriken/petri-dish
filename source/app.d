import std.stdio;
import derelict.sdl2.sdl;

import render;
import render_state;

void main() {
	RenderState state = new RenderState();
	if (!initRenderer(&state)) {
		writeln("an error occurred initializing the renderer");
	}

	bool quit = false;
	while (!quit) {
		// handle event queue
		SDL_Event event;
		while (SDL_PollEvent(&event) != 0) {
			if (event.type == SDL_QUIT) {
				quit = true;
			}
		}
	}

	cleanup(&state);
}
