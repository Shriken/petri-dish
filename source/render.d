import derelict.sdl2.sdl;

import render_utils;
import state.state;

void render(State state) {
	auto renderState = state.renderState;

	// clear screen
	renderState.renderClear();

	foreach (widget; renderState.widgets) {
		widget.render(state);
	}

	SDL_RenderPresent(renderState.renderer);
}
