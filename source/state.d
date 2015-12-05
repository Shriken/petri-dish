import sim_state;
import render_state;

class State {
	SimulationState simState;
	RenderState renderState;
	bool paused = false;

	this() {
		this.simState = new SimulationState();
		this.renderState = new RenderState();
	}
};
