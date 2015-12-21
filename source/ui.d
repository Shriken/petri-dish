import std.algorithm;
import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.transforms;
import state.state;
import widget.widget;
import widget.experiment_widget;

class UI {
	private Widget focus;
	private Widget[] widgets;

	vec2i dimensions;

	this(vec2i dimensions) {
		this.dimensions = dimensions;
		this.widgets ~= new ExperimentWidget(vec2i(0, 0), dimensions);
	}

	void render(State state) {
		auto renderState = state.renderState;

		// clear screen
		SDL_RenderSetViewport(renderState.renderer, null);
		renderState.renderClear();

		foreach (widget; widgets) {
			auto clipRect = getRectFromVectors(
				widget.offset,
				widget.dimensions
			);
			SDL_RenderSetViewport(renderState.renderer, &clipRect);
			widget.render(state);
		}

		SDL_RenderPresent(renderState.renderer);
	}

	void removeWidget(Widget widget) {
		if (widget is focus) {
			focus = null;
		}
		widgets = widgets.remove(widgets.countUntil(widget));
	}

	@property focusedWidget() {
		scope (failure) return null;
		if (focus is null) {
			focus = widgets[0];
		}

		return focus;
	}

	void handleEvent(State state, SDL_Event event) {
		switch (event.type) {
			case SDL_QUIT:
				state.simState.running = false;
				break;
			case SDL_KEYDOWN:
				handleKey(state, event.key.keysym.sym);
				break;
			case SDL_MOUSEBUTTONDOWN:
				handleClick(state, event.button);
				break;
			default:
				break;
		}
	}

	void handleKey(State state, SDL_Keycode keycode) {
		// TODO add focus to the mix
		auto renderState = state.renderState;
		switch (keycode) {
			case SDLK_q:
				state.simState.running = false;
				break;
			case SDLK_p:
				state.paused = !state.paused;
				break;
			case SDLK_d:
				renderState.debugRender = !renderState.debugRender;
				break;
			default:
				break;
		}
	}

	void handleClick(State state, SDL_MouseButtonEvent event) {
		auto curHeight = -1;
		Widget curWidget = null;
		foreach (widget; widgets) {
			if (
				widget.offset.x <= event.x &&
				event.x <= widget.offset.x + widget.dimensions.x &&
				widget.offset.y <= event.y &&
				event.y <= widget.offset.y + widget.dimensions.y
			) {
				if (widget.height > curHeight) {
					curWidget = widget;
					curHeight = curWidget.height;
				}
			}
		}

		event.x -= curWidget.offset.x;
		event.y -= curWidget.offset.y;
		curWidget.handleClick(state, event);
	}
}
