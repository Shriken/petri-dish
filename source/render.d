import derelict.sdl2.sdl;

import render_utils;
import state.state;

void render(State state) {
	// clear screen
	state.renderState.renderClear();

	foreach (widget; state.renderState.widgets) {
		widget.render(state);
	}

	SDL_RenderPresent(state.renderState.renderer);
}
