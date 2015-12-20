module widget.debug_widget;

import std.conv;
import derelict.sdl2.sdl;

import render_utils;
import state.state;
import widget.widget;

class DebugWidget : Widget {
	override {
		void render(State state) {
			// draw fps in top left
			auto fpsText = to!string(state.fps);
			drawText(state.renderState, fpsText, 0, 0);
		}

		void handleEvent(SDL_Event event) {}
	}
}
