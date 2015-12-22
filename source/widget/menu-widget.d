module widget.menu_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.transforms;
import state.state;
import widget.widget;
import widget.button_widget;

class MenuWidget : Widget {
	ButtonWidget[] buttons;

	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);

		auto buttonDimensions = vec2i(200, 50);
		buttons ~= new ButtonWidget(
			dimensions / 2 - buttonDimensions / 2,
			buttonDimensions
		);
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
				auto clipRect = getRectFromVectors(
					button.offset,
					button.offset + button.dimensions
				);
				SDL_RenderSetViewport(renderState.renderer, &clipRect);
				button.render(state);
			}
		}

		void handleClick(State state, SDL_MouseButtonEvent event) {}
	}
}
