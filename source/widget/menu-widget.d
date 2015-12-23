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
		foreach (i; 0 .. 3) {
			buttons ~= new ButtonWidget("stuff!");
		}
		updatePosition(offset, dimensions);
	}

	override {
		void render(State state, ) {
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
		void updatePosition(vec2i offset, vec2i dimensions) {
			this.offset = offset;
			this.dimensions = dimensions;

			auto baseOffset = offset + vec2i(
				dimensions.x / 2,
				dimensions.y / 3
			);
			auto interButtonSpace = 20;
			foreach (int i, ButtonWidget button; buttons) {
				button.dimensions = vec2i(200, 50);
				button.offset = baseOffset - button.dimensions / 2;
				button.offset.y += i * (button.dimensions.y + interButtonSpace);
			}
		}
	}
}
