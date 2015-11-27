module render_state;

import derelict.sdl2.sdl;

class RenderState {
	bool running = true;
	int windowWidth  = 640;
	int windowHeight = 480;
	SDL_Window *window = null;
};
