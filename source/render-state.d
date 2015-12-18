module render_state;

import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

class RenderState {
	vec2i windowDimensions = vec2i(640, 640);
	SDL_Window *window = null;
	SDL_Renderer *renderer = null;

	bool debugRender = true;
	TTF_Font *debugTextFont;
	vec2d scale = vec2d(1, 1);
};

vec2d worldToRenderCoords(RenderState state, vec2d point) {
	return point + state.windowDimensions / 2;
}
