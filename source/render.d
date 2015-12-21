import derelict.sdl2.sdl;

import render_utils;
import misc.transforms;
import state.state;

void render(State state) {
	auto renderState = state.renderState;

	// clear screen
	SDL_RenderSetViewport(renderState.renderer, null);
	renderState.renderClear();

	foreach (widget; renderState.widgets) {
		auto clipRect = getRectFromVectors(
			widget.offset,
			widget.dimensions
		);
		SDL_RenderSetViewport(renderState.renderer, &clipRect);
		widget.render(state);
	}

	SDL_RenderPresent(renderState.renderer);
}
