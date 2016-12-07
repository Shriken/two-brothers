module widget.display_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.coords;
import state.state;
import widget.widget;

class DisplayWidget : Widget {
	string function(State state) displayFunc;
	SDL_Color color = SDL_Color(0x20, 0x20, 0x60);

	this(
		RenderCoords dimensions,
		string function(State state) displayFunc
	) {
		super(RenderCoords(0, 0), dimensions);
		this.displayFunc = displayFunc;
	}

	override {
		void renderSelf(State state) {
			fillRect(
				state.renderState,
				RenderCoords(0, 0),
				dimensions,
				color,
				0xff
			);

			auto center = dimensions / 2;
			drawTextCentered(
				state.renderState,
				displayFunc(state),
				state.renderState.buttonFont,
				center.x,
				center.y,
			);
		}

		void clickHandler(State state, SDL_MouseButtonEvent event) {}
	}
}
