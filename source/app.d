import std.stdio;
import derelict.sdl2.sdl;

import render;
import render_state;

void main() {
	RenderState state = new RenderState();
	if (!initRenderer(&state)) {
		writeln("an error occurred initializing the renderer");
	}

	while (1) {}
}
