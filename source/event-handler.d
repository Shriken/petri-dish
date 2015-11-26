module event_handler;

import derelict.sdl2.sdl;

import render_state;

void handleEvent(RenderState *state, SDL_Event event) {
	if (event.type == SDL_QUIT) {
		state.running = false;
	}
}
