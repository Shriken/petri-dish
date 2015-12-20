module widget.experiment_widget;

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
		}

		void handleEvent(SDL_Event event) {}
	}
}
