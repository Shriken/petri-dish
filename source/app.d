import std.conv;
import std.path;
import std.stdio;
import std.datetime;
import std.algorithm;
import core.thread;
import derelict.sdl2.sdl;

import event;
import render;
import update;
import misc.resources;
import state.state;

const int TICKS_PER_SECOND = 60;
const int MICROS_PER_SECOND = 1_000_000;
const int MICROS_PER_TICK = MICROS_PER_SECOND / TICKS_PER_SECOND;
const int SLEEP_THRESHOLD = 1_000;

void main(string[] args) {
	setBasePath(buildNormalizedPath(args[0], ".."));

	State state = new State();
	if (!initRenderer(state.renderState)) {
		writeln("an error occurred initializing the renderer");
		return;
	}

	while (state.simState.running) {
		// cap ticks-per-second
		auto mt = measureTime!((TickDuration duration) {
			state.fps = MICROS_PER_SECOND / (cast(double)duration.usecs);
			state.fps = min(state.fps, TICKS_PER_SECOND);

			auto usecsLeft = MICROS_PER_TICK - duration.usecs;
			if (usecsLeft > SLEEP_THRESHOLD) {
				Thread.sleep(dur!"usecs"(usecsLeft));
			}
		});

		// handle event queue
		SDL_Event event;
		while (SDL_PollEvent(&event) != 0) {
			handleEvent(state, event);
		}

		// update and render
		if (!state.paused) {
			update.update(state.simState);
		}
		render.render(state);
	}

	cleanupRenderer(state.renderState);
}
