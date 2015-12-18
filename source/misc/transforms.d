module misc.transforms;

import gfm.math.vector;
import derelict.sdl2.sdl;

SDL_Rect getRectFromVectors(
	vec2d topLeft,
	vec2d botRight
) {
	SDL_Rect rect;
	rect.x = cast(int)topLeft.x;
	rect.y = cast(int)topLeft.y;

	auto dimensions = botRight - topLeft;
	rect.w = cast(int)dimensions.x;
	rect.h = cast(int)dimensions.y;

	return rect;
}
