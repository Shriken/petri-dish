module widget.experiment_render_utils;

import derelict.sdl2.sdl;

static import render_utils;
import misc.coords;
import state.render_state;
import widget.experiment_widget;

struct ExperimentRenderState {
	private ExperimentWidget parent;

	// state for panning and zooming
	WorldCoords centerPoint = WorldCoords(0, 0);
	double zoomLevel = 1;
	RenderState globalState;

	this(ExperimentWidget parent) {
		this.parent = parent;
	}

	@property RenderCoords widgetDimensions() {
		return parent.dimensions;
	}
}

RenderCoords worldToRenderCoords(
	ExperimentRenderState state,
	WorldCoords point
) {
	auto zoomedPoint = state.zoomLevel * (point - state.centerPoint);
	return (
		state.widgetDimensions / 2 +
		RenderCoords(
			cast(int)zoomedPoint.x,
			cast(int)zoomedPoint.y
		)
	);
}

RenderCoords worldToRenderDimensions(
	ExperimentRenderState state,
	WorldCoords dimensions
) {
	dimensions *= state.zoomLevel;
	return RenderCoords(cast(int)dimensions.x, cast(int)dimensions.y);
}

void drawRect(
	ExperimentRenderState state,
	WorldCoords topLeft,
	WorldCoords dimensions,
	SDL_Color color,
	ubyte alpha
) {
	render_utils.drawRect(
		state.globalState,
		state.worldToRenderCoords(topLeft),
		state.worldToRenderDimensions(dimensions),
		color,
		alpha
	);
}

void fillRect(
	ExperimentRenderState state,
	WorldCoords topLeft,
	WorldCoords dimensions,
	SDL_Color color,
	ubyte alpha
) {
	render_utils.fillRect(
		state.globalState,
		state.worldToRenderCoords(topLeft),
		state.worldToRenderDimensions(dimensions),
		color,
		alpha
	);
}

void drawLine(
	ExperimentRenderState state,
	WorldCoords point1,
	WorldCoords point2,
	SDL_Color color,
	ubyte alpha
) {
	render_utils.drawLine(
		state.globalState,
		state.worldToRenderCoords(point1),
		state.worldToRenderCoords(point2),
		color,
		alpha
	);
}

void drawBoundaries(ExperimentRenderState state) {
}
