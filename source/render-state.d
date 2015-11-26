module render_state;

import derelict.sdl2.sdl;

class RenderState {
	bool running = true;
	SDL_Window *window = null;
};
