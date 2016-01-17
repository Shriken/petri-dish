module widget.experiment_widget;

import std.conv;
import std.datetime;
import derelict.sdl2.sdl;

static import render_utils;
import misc.coords;
import actor.cell;
import actor.food;
import state.state;
import state.render_state;
import widget.widget;
import widget.experiment_render_utils;

enum DragState {
	notDragging,
	notYetDragging,
	dragging
}

/**
 * Widget that displays an experiment
 * Can't think of a better name right now
 */
class ExperimentWidget : Widget {
	const Duration TIME_DEADZONE = dur!"msecs"(100);

	ExperimentRenderState renderState;

	DragState dragState = DragState.notDragging;
	RenderCoords dragMovement;
	SysTime dragStartTime;

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

			// draw boundaries
			auto experimentRad = state.simState.FIELD_RAD;
			renderState.drawRect(
				WorldCoords(-experimentRad, -experimentRad),
				WorldCoords(2 * experimentRad, 2 * experimentRad),
				render_utils.WHITE,
				0xff,
			);

			// debug rendering
			if (state.renderState.debugRender) {
				debugRender(state);
			}
		}

		void clickHandler(State state, SDL_MouseButtonEvent event) {
			if (event.type is SDL_MOUSEBUTTONUP) {
				// if we weren't dragging, we clicked
				if (dragState is DragState.notYetDragging) {
					auto point = renderState.renderToWorldCoords(
						RenderCoords(event.x, event.y)
					);
					state.simState.addCell(point.x, point.y);
				}

				// done dragging
				dragState = DragState.notDragging;
			} else if (event.type is SDL_MOUSEBUTTONDOWN) {
				dragState = DragState.notYetDragging;
				dragStartTime = Clock.currTime;
				dragMovement = RenderCoords(0, 0);
			}
		}

		void scrollHandler(State state, SDL_MouseWheelEvent event) {
			renderState.zoomLevel *= 1.01 ^^ event.y;
			if (renderState.zoomLevel < 0.8) {
				renderState.zoomLevel = 0.8;
			}
		}

		void motionHandler(State state, SDL_MouseMotionEvent event) {
			if (event.state & SDL_BUTTON_LMASK) {
				if (
					dragState is DragState.notYetDragging &&
					Clock.currTime - dragStartTime > TIME_DEADZONE
				) {
					dragState = DragState.dragging;
					renderState.centerPoint -= renderToWorldDimensions(
						renderState,
						dragMovement
					);
				}

				// if the mouse is being dragged
				if (dragState is DragState.dragging) {
					// pan viewport
					renderState.centerPoint -= renderToWorldDimensions(
						renderState,
						RenderCoords(event.xrel, event.yrel)
					);
				} else {
					dragMovement += RenderCoords(event.xrel, event.yrel);
				}
			}
		}
	}

	void debugRender(State state) {
		// draw fps in top left
		render_utils.drawText(
			state.renderState,
			to!string(state.fps),
			state.renderState.debugTextFont,
			0, 0
		);
	}
}
