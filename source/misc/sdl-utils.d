module misc.sdl_utils;

import derelict.sdl2.sdl;

void setRenderDrawColor(
	SDL_Renderer *renderer,
	SDL_Color color,
	ubyte alpha
) {
	SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, alpha);
}
