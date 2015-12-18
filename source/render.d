import std.conv;
import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import cell;
import food;
import state;
import render_state;

void render(State *state) {
	auto renderState = &state.renderState;

	// clear screen
	SDL_SetRenderDrawColor(renderState.renderer, 0, 0, 0, 0xff);
	SDL_RenderClear(renderState.renderer);

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

void renderDebug(State *state) {
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
	RenderState *state,
	Vector!(double, 2) topLeft,
	Vector!(double, 2) dimensions,
	ubyte r,
	ubyte g,
	ubyte b,
	ubyte a,
) {
	SDL_Rect rect;
	rect.x = cast(int)topLeft.x + state.windowWidth  / 2;
	rect.y = cast(int)topLeft.y + state.windowHeight / 2;
	rect.w = cast(int)dimensions.x;
	rect.h = cast(int)dimensions.y;

	SDL_SetRenderDrawColor(state.renderer, r, g, b, a);
	SDL_RenderFillRect(state.renderer, &rect);
}

void drawLine(
	RenderState *state,
	Vector!(double, 2) point1,
	Vector!(double, 2) point2,
	ubyte r,
	ubyte g,
	ubyte b,
	ubyte a,
) {
	int x1 = cast(int)point1.x + state.windowWidth  / 2;
	int y1 = cast(int)point1.y + state.windowHeight / 2;
	int x2 = cast(int)point2.x + state.windowWidth  / 2;
	int y2 = cast(int)point2.y + state.windowHeight / 2;

	SDL_SetRenderDrawColor(state.renderer, r, g, b, a);
	SDL_RenderDrawLine(state.renderer, x1, y1, x2, y2);
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
		SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
	);

	int x, y;
	SDL_GL_GetDrawableSize(state.window, &x, &y);
	state.scale.x = 1. * x / state.windowWidth;
	state.scale.y = 1. * y / state.windowHeight;

	if (state.window is null) {
		return false;
	}

	state.renderer = SDL_CreateRenderer(state.window, -1, 0);
	SDL_RenderSetScale(state.renderer, state.scale.x, state.scale.y);

	DerelictSDL2ttf.load();

	if (TTF_Init() != 0) {
		writeln("failed to init ttf");
		return false;
	}

	state.debugTextFont = TTF_OpenFont("res/monaco.ttf", 10);
	if (state.debugTextFont is null) {
		writeln("font not present");
		return false;
	}

	return true;
}

void cleanupRenderer(RenderState *state) {
	SDL_DestroyWindow(state.window);
	SDL_Quit();
}
