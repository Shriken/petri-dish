module widget.button_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import state.state;
import widget.widget;

class ButtonWidget : Widget {
	string text;
	SDL_Color color = SDL_Color(0x20, 0x5a, 0x3a);

	this(string text) {
		super(vec2i(0, 0), vec2i(0, 0));

		this.text = text;
	}

	override {
		void renderSelf(State state) {
			drawRect(
				state.renderState,
				vec2i(0, 0),
				dimensions,
				color,
				0xff
			);

			auto center = dimensions / 2;
			drawTextCentered(
				state.renderState,
				text,
				state.renderState.buttonFont,
				center.x,
				center.y,
			);
		}

		void handleClick(State state, SDL_MouseButtonEvent event) {}
	}
}
