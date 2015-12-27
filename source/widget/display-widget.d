module widget.display_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import state.state;
import widget.widget;

class DisplayWidget : Widget {
	string delegate(State state) displayFunc;
	SDL_Color color = SDL_Color(0x20, 0x20, 0x60);

	this(
		string delegate(State state) displayFunc
	) {
		super(vec2i(0, 0), vec2i(0, 0));
		this.displayFunc = displayFunc;
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
				displayFunc(state),
				state.renderState.buttonFont,
				center.x,
				center.y,
			);
		}

		void clickHandler(State state, SDL_MouseButtonEvent event) {}
	}
}
