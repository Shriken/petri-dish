module render_state;

import derelict.sdl2.sdl;

class RenderState {
	int windowWidth  = 640;
	int windowHeight = 480;
	SDL_Window *window = null;
	SDL_Surface *windowSurface = null;
	SDL_Renderer *renderer = null;
};
