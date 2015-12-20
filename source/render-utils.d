module render_utils;

import std.conv;
import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import misc.transforms;
import state.render_state;

void setRenderDrawColor(
	SDL_Renderer *renderer,
	SDL_Color color,
	ubyte alpha
) {
	SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, alpha);
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

void renderClear(RenderState state) {
	SDL_SetRenderDrawColor(state.renderer, 0, 0, 0, 0xff);
	SDL_RenderClear(state.renderer);
}
