module misc.rect;

import derelict.sdl2.sdl;

bool pointInRect(Vec_T)(
	Vec_T point,
	Vec_T rectTopLeft,
	Vec_T rectDimensions
) {
	auto pointDiff = point - rectTopLeft;
	return (
		pointDiff.x > 0 &&
		pointDiff.y > 0 &&
		pointDiff.x < rectDimensions.x &&
		pointDiff.y < rectDimensions.y
	);
}
