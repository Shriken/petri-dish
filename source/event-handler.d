module event_handler;

import derelict.sdl2.sdl;

import state;

void handleEvent(State *state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.simState.running = false;
			break;
		case SDL_KEYDOWN:
			handleKey(state, event.key.keysym.sym);
			break;
		case SDL_MOUSEBUTTONDOWN:
			handleClick(state, event.button);
			break;
		default:
			break;
	}
}

void handleKey(State *state, SDL_Keycode keycode) {
	switch (keycode) {
		case SDLK_q:
			state.simState.running = false;
			break;
		case SDLK_p:
			state.paused = !state.paused;
			break;
		default:
			break;
	}
}

void handleClick(State *state, SDL_MouseButtonEvent event) {
	if (event.type == SDL_MOUSEBUTTONDOWN) {
		state.simState.addCell(
			event.x - state.simState.FIELD_RAD,
			event.y - state.simState.FIELD_RAD
		);
	}
}
