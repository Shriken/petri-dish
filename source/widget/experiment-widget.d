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
	override {
		void render(State state) {
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

		void handleEvent(SDL_Event event) {}
	}

	void debugRender(State state) {
		// draw fps in top left
		auto fpsText = to!(char[])(state.fps);
		fpsText ~= '\0';
		drawText(state.renderState, fpsText.idup, 0, 0);
	}
}
