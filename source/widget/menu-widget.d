module widget.menu_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.rect;
import misc.coords;
import state.state;
import widget.widget;
import widget.button_widget;

class MenuWidget : Widget {
	this(RenderCoords offset, RenderCoords dimensions) {
		super(offset, dimensions);
	}

	override {
		void renderSelf(State state) {
			auto renderState = state.renderState;

			drawRect(
				renderState,
				RenderCoords(0, 0),
				dimensions,
				SDL_Color(0xff, 0xff, 0xff),
				0x80
			);
		}

		void clickHandler(State state, SDL_MouseButtonEvent event) {}

		void updatePosition(RenderCoords offset, RenderCoords dimensions) {
			this.offset = offset;
			this.dimensions = dimensions;

			auto baseOffset = offset + RenderCoords(
				dimensions.x / 2,
				dimensions.y / 3
			);
			auto interButtonSpace = 20;
			foreach (int i, Widget child; children) {
				// update children positions and dimensions
				child.offset = baseOffset - child.dimensions / 2;
				child.offset.y += i *
					(child.dimensions.y + interButtonSpace);
			}
		}
	}
}
