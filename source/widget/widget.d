module widget.widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import misc.rect;
import misc.transforms;
import state.state;

abstract class Widget {
	Widget[] children;

	vec2i offset;
	vec2i dimensions;

	this(vec2i offset, vec2i dimensions) {
		updatePosition(offset, dimensions);
	}

	/* DO NOT OVERRIDE */
	void render(State state) {
		renderSelf(state);
		renderChildren(state);
	}

	void renderSelf(State state);
	void renderChildren(State state) {
		foreach (child; children) {
			auto clipRect = getRectFromVectors(
				child.offset,
				child.offset + child.dimensions
			);
			SDL_RenderSetViewport(state.renderState.renderer, &clipRect);
			child.render(state);
		}
	}

	/* DO NOT OVERRIDE */
	void handleClick(State state, SDL_MouseButtonEvent event) {
		foreach (child; children) {
			if (
				pointInRect(
					vec2i(event.x, event.y),
					child.offset,
					child.dimensions
				)
			) {
				child.handleClick(state, event);
				return;
			}
		}

		clickHandler(state, event);
	}

	void clickHandler(State state, SDL_MouseButtonEvent event);

	void updatePosition(vec2i offset, vec2i dimensions) {
		this.offset = offset;
		this.dimensions = dimensions;
	}
}
