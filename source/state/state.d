module state.state;

import ui;
import state.sim_state;
import state.render_state;

class State {
	SimulationState simState;
	RenderState renderState;
	UI ui;
	double fps;

	this() {
		this.simState = new SimulationState();
		this.renderState = new RenderState();
		this.ui = new UI(renderState.windowDimensions);
	}
};
