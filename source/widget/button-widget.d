module widget.button_widget;

import std.typecons;
import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import state.state;
import widget.widget;

alias ClickFunction = Typedef!(
	void function(
		ButtonWidget thisWidget,
		State state,
		SDL_MouseButtonEvent event
	)
);

class ButtonWidget : Widget {
	string text;
	SDL_Color color = SDL_Color(0x20, 0x5a, 0x3a);
	ClickFunction clickFunc;

	this(
		string text,
		vec2i dimensions,
		ClickFunction clickFunc
	) {
		super(vec2i(0, 0), dimensions);
		this.text = text;
		this.clickFunc = clickFunc;
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

		void clickHandler(State state, SDL_MouseButtonEvent event) {
			this.clickFunc(this, state, event);
		}
	}
}
