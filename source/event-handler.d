module event_handler;

import derelict.sdl2.sdl;

import state;

void handleEvent(State *state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.simState.running = false;
			break;
		case SDL_KEYDOWN:
			if (event.key.keysym.sym == SDLK_q) {
				state.simState.running = false;
			}
			break;
		default:
			break;
	}
}
