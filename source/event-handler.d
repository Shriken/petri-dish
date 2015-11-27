module event_handler;

import derelict.sdl2.sdl;

import render_state;

void handleEvent(RenderState *state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.running = false;
			break;
		case SDL_KEYDOWN:
			if (event.key.keysym.sym == SDLK_q) {
				state.running = false;
			}
			break;
		default:
			break;
	}
}
