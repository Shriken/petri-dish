import std.conv;
import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import misc.resources;
import misc.sdl_utils;
import misc.transforms;
import actor.cell;
import actor.food;
import state.state;
import state.render_state;

void render(State state) {
	auto renderState = state.renderState;

	// clear screen
	renderState.clear();

	// render food
	foreach (ref Food food; state.simState.food) {
		food.render(renderState);
	}

	// render cells
	foreach (ref Cell cell; state.simState.cells) {
		cell.render(renderState);
	}

	// render debug stuffs
	if (renderState.debugRender) {
		renderDebug(state);
	}

	SDL_RenderPresent(renderState.renderer);
}

void clear(RenderState state) {
	SDL_SetRenderDrawColor(state.renderer, 0, 0, 0, 0xff);
	SDL_RenderClear(state.renderer);
}

void renderDebug(State state) {
	// draw fps in top left
	auto fpsText = to!(char[])(state.fps);
	fpsText ~= '\0';
	drawText(state.renderState, fpsText, 0, 0);
}

void drawText(RenderState state, char[] text, int x, int y) {
	auto color = SDL_Color(0xff, 0xff, 0xff, 0xff);
	auto textSurface = TTF_RenderText_Solid(
		state.debugTextFont,
		text.ptr,
		color
	);
	if (textSurface is null) {
		writeln(to!string(SDL_GetError()));
		return;
	}

	auto textTexture = SDL_CreateTextureFromSurface(
		state.renderer,
		textSurface
	);
	if (textTexture is null) {
		writeln(to!string(SDL_GetError()));
		return;
	}

	SDL_Rect targetLoc;
	targetLoc.x = x;
	targetLoc.y = y;
	targetLoc.w = textSurface.w;
	targetLoc.h = textSurface.h;
	SDL_RenderCopy(state.renderer, textTexture, null, &targetLoc);
	SDL_FreeSurface(textSurface);
}

void drawRect(
	RenderState state,
	vec2d topLeft,
	vec2d dimensions,
	SDL_Color color,
	ubyte alpha,
) {
	auto renderTopLeft = state.worldToRenderCoords(topLeft);
	auto drawRect = getRectFromVectors(
		renderTopLeft,
		renderTopLeft + dimensions
	);
	setRenderDrawColor(state.renderer, color, alpha);
	SDL_RenderFillRect(state.renderer, &drawRect);
}

void drawLine(
	RenderState state,
	Vector!(double, 2) point1,
	Vector!(double, 2) point2,
	SDL_Color color,
	ubyte alpha,
) {
	point1 = state.worldToRenderCoords(point1);
	point2 = state.worldToRenderCoords(point2);

	setRenderDrawColor(state.renderer, color, alpha);
	SDL_RenderDrawLine(
		state.renderer,
		cast(int)point1.x,
		cast(int)point1.y,
		cast(int)point2.x,
		cast(int)point2.y
	);
}

bool initRenderer(RenderState state) {
	// set up SDL
	DerelictSDL2.load();
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		writeln("failed to init sdl video");
		return false;
	}

	// create the game window
	state.window = SDL_CreateWindow(
		"Petri dish",
		SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED,
		state.windowDimensions.x,
		state.windowDimensions.y,
		SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
	);
	if (state.window is null) {
		return false;
	}

	// determine the scale we're working at
	int x, y;
	SDL_GL_GetDrawableSize(state.window, &x, &y);
	state.scale.x = 1. * x / state.windowDimensions.x;
	state.scale.y = 1. * y / state.windowDimensions.y;

	// initialize the renderer
	state.renderer = SDL_CreateRenderer(state.window, -1, 0);
	SDL_RenderSetScale(state.renderer, state.scale.x, state.scale.y);

	// set up sdl_ttf
	DerelictSDL2ttf.load();
	if (TTF_Init() != 0) {
		writeln("failed to init ttf");
		return false;
	}

	// load the font
	state.debugTextFont = TTF_OpenFont(
		getResourcePath("monaco.ttf").dup.ptr,
		10
	);
	if (state.debugTextFont is null) {
		writeln("font not present");
		return false;
	}

	return true;
}

void cleanupRenderer(RenderState state) {
	SDL_DestroyRenderer(state.renderer);
	SDL_DestroyWindow(state.window);
	SDL_Quit();
}
