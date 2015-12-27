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
		render(state, vec2i(0, 0));
	}

	/* DO NOT OVERRIDE */
	void render(State state, vec2i existingOffset) {
		renderSelf(state);
		renderChildren(state, existingOffset);
	}

	void renderSelf(State state);
	void renderChildren(State state, vec2i existingOffset) {
		foreach (child; children) {
			auto totalOffset = existingOffset + this.offset;
			auto clipRect = getRectFromVectors(
				totalOffset + child.offset,
				totalOffset + child.offset + child.dimensions
			);
			SDL_RenderSetViewport(state.renderState.renderer, &clipRect);
			child.render(state, totalOffset);
		}
	}

	/* DO NOT OVERRIDE */
	void handleClick(State state, SDL_MouseButtonEvent event) {
		foreach (child; children) {
			if (child.containsPoint(event)) {
				event.x -= child.offset.x;
				event.y -= child.offset.y;
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

	bool containsPoint(Vec_T)(Vec_T point) {
		return pointInRect(
			vec2i(point.x, point.y),
			offset,
			dimensions
		);
	}
}
