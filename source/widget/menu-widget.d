module widget.menu_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import state.state;
import widget.widget;
import widget.button_widget;

class MenuWidget : Widget {
	ButtonWidget[] buttons;

	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);
	}

	override {
		void render(State state) {
			auto renderState = state.renderState;

			drawRect(
				renderState,
				vec2i(0, 0),
				dimensions,
				SDL_Color(0xff, 0xff, 0xff),
				0x80
			);

			foreach (button; buttons) {
				button.render(state);
			}
		}

		void handleClick(State state, SDL_MouseButtonEvent event) {}
	}
}
