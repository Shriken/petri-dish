module widget.button_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import state.state;
import widget.widget;

class ButtonWidget : Widget {
	string text;
	SDL_Color color = SDL_Color(0x20, 0x5a, 0x3a);

	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);
	}

	override {
		void render(State state) {
			drawRect(
				state.renderState,
				vec2i(0, 0),
				dimensions,
				color,
				0xff
			);
		}

		void handleClick(State state, SDL_MouseButtonEvent event) {}
	}
}
