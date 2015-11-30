import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;

import cell;
import state;
import render_state;

void render(State *state) {
	// clear screen
	RenderState *renderState = &state.renderState;
	SDL_SetRenderDrawColor(renderState.renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderState.renderer);

	foreach (ref Cell cell; state.simState.cells) {
		cell.render(renderState);
	}

	SDL_RenderPresent(renderState.renderer);
}

void drawRect(
	RenderState *state,
	Vector!(double, 2) topLeft,
	Vector!(double, 2) dimensions,
) {
	SDL_Rect rect;
	rect.x = cast(int)topLeft.x + state.windowWidth  / 2;
	rect.y = cast(int)topLeft.y + state.windowHeight / 2;
	rect.w = cast(int)dimensions.x;
	rect.h = cast(int)dimensions.y;

	SDL_SetRenderDrawColor(state.renderer, 255, 0, 0, 255);
	SDL_RenderFillRect(state.renderer, &rect);
}

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

	state.renderer = SDL_CreateRenderer(state.window, -1, 0);

	return true;
}

void cleanupRenderer(RenderState *state) {
	SDL_DestroyWindow(state.window);
	SDL_Quit();
}
