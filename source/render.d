import std.conv;
import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import render_utils;
import misc.resources;
import state.state;
import state.render_state;
import widget.widget;

void render(State state) {
	auto renderState = state.renderState;

	// clear screen
	renderState.renderClear();

	foreach (widget; renderState.widgets) {
		widget.render(state);
	}

	// render debug stuffs
	if (renderState.debugRender) {
		renderDebug(state);
	}

	SDL_RenderPresent(renderState.renderer);
}

void renderDebug(State state) {
	// draw fps in top left
	auto fpsText = to!(char[])(state.fps);
	fpsText ~= '\0';
	drawText(state.renderState, fpsText, 0, 0);
}
