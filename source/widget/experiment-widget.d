module widget.experiment_widget;

import std.conv;
import derelict.sdl2.sdl;

import render_utils;
import misc.coords;
import actor.cell;
import actor.food;
import state.state;
import state.render_state;
import widget.widget;
import widget.experiment_render_utils;

/**
 * Widget that displays an experiment
 * Can't think of a better name right now
 */
class ExperimentWidget : Widget {
	ExperimentRenderState renderState;

	this(RenderCoords offset, RenderCoords dimensions) {
		super(offset, dimensions);
		this.renderState = ExperimentRenderState(this);
	}

	override {
		void renderSelf(State state) {
			renderState.globalState = state.renderState;

			// render food
			foreach (food; state.simState.food) {
				food.render(renderState);
			}

			// render cells
			foreach (cell; state.simState.cells) {
				cell.render(renderState);
			}

			// debug rendering
			if (state.renderState.debugRender) {
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
			renderState.zoomLevel *= 1.01 ^^ event.y;
			if (renderState.zoomLevel < 1) {
				renderState.zoomLevel = 1;
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
