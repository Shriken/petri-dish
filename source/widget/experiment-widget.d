module widget.experiment_widget;

import std.conv;
import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
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
	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);
	}

	override {
		void renderSelf(State state) {
			auto renderState = state.renderState;

			// render food
			foreach (food; state.simState.food) {
				food.render(renderState);
			}

			// render cells
			foreach (cell; state.simState.cells) {
				cell.render(renderState);
			}

			// debug rendering
			if (renderState.debugRender) {
				debugRender(state);
			}
		}

		void handleClick(State state, SDL_MouseButtonEvent event) {
			if (event.type == SDL_MOUSEBUTTONDOWN) {
				state.simState.addCell(
					event.x - state.simState.FIELD_RAD,
					event.y - state.simState.FIELD_RAD
				);
			}
		}
	}

	void debugRender(State state) {
		// draw fps in top left
		auto fpsText = to!(char[])(state.fps);
		fpsText ~= '\0';
		auto renderState = state.renderState;
		drawText(
			renderState,
			fpsText.idup,
			renderState.debugTextFont,
			0, 0
		);
	}
}
