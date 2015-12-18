module render_state;

import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

class RenderState {
	int windowWidth  = 640;
	int windowHeight = 640;
	SDL_Window *window = null;
	SDL_Renderer *renderer = null;

	bool debugRender = true;
	TTF_Font *debugTextFont;
	Vector!(float, 2) scale = Vector!(float, 2)(1, 1);
};
