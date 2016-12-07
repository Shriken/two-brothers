module widget.button_widget;

import std.typecons;
import gfm.math.vector;
import derelict.sdl2.sdl;

import render_utils;
import misc.coords;
import state.state;
import widget.widget;

alias ClickFunction = Typedef!(
	void function(
		State state,
		SDL_MouseButtonEvent event
	)
);

class ButtonWidget : Widget {
	string text;
	SDL_Color color = SDL_Color(0x20, 0x5a, 0x3a);
	ClickFunction clickFunc;

	this(
		string text,
		RenderCoords dimensions,
		ClickFunction clickFunc
	) {
		super(RenderCoords(0, 0), dimensions);
		this.text = text;
		this.clickFunc = clickFunc;
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
				text,
				state.renderState.buttonFont,
				center.x,
				center.y,
			);
		}

		void clickHandler(State state, SDL_MouseButtonEvent event) {
			if (event.state is SDL_RELEASED) {
				this.clickFunc(state, event);
			}
		}
	}
}
