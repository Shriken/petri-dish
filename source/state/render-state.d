module state.render_state;

import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import misc.resources;

class RenderState {
	vec2i windowDimensions = vec2i(640, 640);
	SDL_Window *window = null;
	SDL_Renderer *renderer = null;

	bool debugRender = true;
	TTF_Font *debugTextFont;
	vec2d scale = vec2d(1, 1);

	bool init() {
		// set up SDL
		DerelictSDL2.load();
		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
			writeln("failed to init sdl video");
			return false;
		}

		// create the game window
		window = SDL_CreateWindow(
			"Petri dish",
			SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED,
			windowDimensions.x,
			windowDimensions.y,
			SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
		);
		if (window is null) {
			return false;
		}

		// determine the scale we're working at
		int x, y;
		SDL_GL_GetDrawableSize(window, &x, &y);
		scale.x = 1. * x / windowDimensions.x;
		scale.y = 1. * y / windowDimensions.y;

		// initialize the renderer
		renderer = SDL_CreateRenderer(window, -1, 0);
		SDL_RenderSetScale(renderer, scale.x, scale.y);

		// set up sdl_ttf
		DerelictSDL2ttf.load();
		if (TTF_Init() != 0) {
			writeln("failed to init ttf");
			return false;
		}

		// load the font
		debugTextFont = TTF_OpenFont(
			getResourcePath("monaco.ttf").dup.ptr,
			10
		);
		if (debugTextFont is null) {
			writeln("font not present");
			return false;
		}

		return true;
	}

	~this() {
		SDL_DestroyRenderer(renderer);
		SDL_DestroyWindow(window);
		SDL_Quit();
	}
};

vec2d worldToRenderCoords(RenderState state, vec2d point) {
	return point + state.windowDimensions / 2;
}
