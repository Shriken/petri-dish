module sim_state;

import cell;

class SimulationState {
	bool running = true;
	double FIELD_RAD = 320;
	Cell cell = new Cell();
};
