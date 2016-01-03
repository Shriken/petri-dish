module widget.experiment_widget;

import std.conv;
import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.coords;
import actor.cell;
import actor.food;
import state.state;
import state.render_state;
import widget.widget;

/**
 * Widget that displays an experiment
 * Can't think of a better name right now
 */
class ExperimentWidget : Widget {
	// state for panning and zooming
	WorldCoords centerPoint = WorldCoords(0, 0);
	double zoomLevel = 1;

	this(RenderCoords offset, RenderCoords dimensions) {
		super(offset, dimensions);
	}

	override {
		void renderSelf(State state) {
			auto renderState = state.renderState;

			auto scale = renderState.scale * zoomLevel;
			SDL_RenderSetScale(renderState.renderer, scale, scale);

			// render food
			foreach (food; state.simState.food) {
				food.render(renderState);
			}

			// render cells
			foreach (cell; state.simState.cells) {
				cell.render(renderState);
			}

			SDL_RenderSetScale(
				renderState.renderer,
				renderState.scale,
				renderState.scale
			);

			// debug rendering
			if (renderState.debugRender) {
				debugRender(state);
			}
		}

		void clickHandler(State state, SDL_MouseButtonEvent event) {
			if (event.type == SDL_MOUSEBUTTONDOWN) {
				state.simState.addCell(
					event.x - state.simState.FIELD_RAD,
					event.y - state.simState.FIELD_RAD
				);
			}
		}

		void scrollHandler(State state, SDL_MouseWheelEvent event) {
			zoomLevel *= 1.01 ^^ event.y;
			if (zoomLevel < 1) {
				zoomLevel = 1;
			}
		}
	}

	void debugRender(State state) {
		// draw fps in top left
		state.renderState.drawText(
			to!string(state.fps),
			state.renderState.debugTextFont,
			0, 0
		);
	}
}
