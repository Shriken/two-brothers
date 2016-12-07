module misc.rect;

import derelict.sdl2.sdl;

import misc.coords;

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

SDL_Rect getRectFromVectors(
	RenderCoords topLeft,
	RenderCoords botRight
) {
	SDL_Rect rect;
	rect.x = topLeft.x;
	rect.y = topLeft.y;

	auto dimensions = botRight - topLeft;
	rect.w = dimensions.x;
	rect.h = dimensions.y;

	return rect;
}
