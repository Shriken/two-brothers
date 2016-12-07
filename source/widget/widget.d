module widget.widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import misc.rect;
import misc.coords;
import state.state;

abstract class Widget {
	Widget[] children;

	RenderCoords offset;
	RenderCoords dimensions;

	this(RenderCoords offset, RenderCoords dimensions) {
		updatePosition(offset, dimensions);
	}

	/* DO NOT OVERRIDE */
	void render(State state) {
		render(state, RenderCoords(0, 0));
	}

	/* DO NOT OVERRIDE */
	void render(State state, RenderCoords existingOffset) {
		renderSelf(state);
		renderChildren(state, existingOffset);
	}

	void renderSelf(State state);
	void renderChildren(State state, RenderCoords existingOffset) {
		foreach (child; children) {
			auto totalOffset = existingOffset + this.offset;
			auto clipRect = getRectFromVectors(
				totalOffset + child.offset,
				totalOffset + child.offset + child.dimensions
			);
			SDL_RenderSetViewport(state.renderState.renderer, &clipRect);
			child.render(state, totalOffset);
		}
	}

	/* DO NOT OVERRIDE */
	void handleEvent(State state, SDL_Event event) {
		switch (event.type) {
			case SDL_MOUSEBUTTONDOWN:
				handleClick(state, event.button);
				break;
			case SDL_MOUSEWHEEL:
				scrollHandler(state, event.wheel);
				break;
			case SDL_MOUSEMOTION:
				motionHandler(state, event.motion);
				break;
			default:
				break;
		}
	}

	/* DO NOT OVERRIDE */
	void handleClick(State state, SDL_MouseButtonEvent event) {
		foreach (child; children) {
			if (child.containsPoint(event)) {
				event.x -= child.offset.x;
				event.y -= child.offset.y;
				child.handleClick(state, event);
				return;
			}
		}

		clickHandler(state, event);
	}

	void clickHandler(State state, SDL_MouseButtonEvent event);
	void scrollHandler(State state, SDL_MouseWheelEvent event) {}
	void motionHandler(State state, SDL_MouseMotionEvent event) {}

	void updatePosition(RenderCoords offset, RenderCoords dimensions) {
		this.offset = offset;
		this.dimensions = dimensions;
	}

	bool containsPoint(Vec_T)(Vec_T point) {
		return pointInRect(
			RenderCoords(point.x, point.y),
			offset,
			dimensions
		);
	}
}
