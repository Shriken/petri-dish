import std.stdio;
import derelict.sdl2.sdl;

import render_state;

bool initRenderer(RenderState *state) {
	DerelictSDL2.load();
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		writeln("failed to init sdl video");
		return false;
	}

	state.window = SDL_CreateWindow(
		"Petri dish",
		SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED,
		state.windowWidth,
		state.windowHeight,
		SDL_WINDOW_SHOWN
	);

	if (state.window == null) {
		return false;
	}

	return true;
}

void cleanupRenderer(RenderState *state) {
	SDL_DestroyWindow(state.window);
	SDL_Quit();
}
