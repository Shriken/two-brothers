module widget.button_display_cluster_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import misc.coords;
import state.state;
import widget.widget;
import widget.button_widget;
import widget.display_widget;

class ButtonDisplayClusterWidget : Widget {
	this(
		RenderCoords dimensions,
		ClickFunction leftButtonClickFunc,
		string function(State state) displayFunc,
		ClickFunction rightButtonClickFunc,
	) {
		super(RenderCoords(0, 0), dimensions);
		auto buttonSize = dimensions;
		buttonSize.x /= 4;
		auto displaySize = dimensions;
		displaySize.x /= 2;

		// left button
		children ~= new ButtonWidget("<", buttonSize, leftButtonClickFunc);

		// display
		auto display = new DisplayWidget(displaySize, displayFunc);
		display.offset = RenderCoords(buttonSize.x, 0);
		children ~= display;

		// right button
		auto rightButton = new ButtonWidget(
			">",
			buttonSize,
			rightButtonClickFunc
		);
		rightButton.offset = RenderCoords(
			buttonSize.x + displaySize.x,
			0
		);
		children ~= rightButton;
	}

	override {
		void renderSelf(State state) {}
		void clickHandler(State state, SDL_MouseButtonEvent event) {}
	}
}
