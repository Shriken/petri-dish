module widget.button_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import state.state;
import widget.widget;

class ButtonWidget : Widget {
	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);
	}

	override {
		void render(State state) {}
		void handleClick(State state, SDL_MouseButtonEvent event) {}
	}
}
