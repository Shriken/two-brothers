module state.state;

import core.thread;
import std.algorithm;
import std.datetime;
import std.range;

import derelict.sdl2.sdl;

import graph;
import misc.coords;
import state.render_state;
import state.sim_state;
import widget.button_widget;
import widget.widget;

const int TICKS_PER_SECOND = 60;
const int MICROS_PER_SECOND = 1_000_000;
const int MICROS_PER_TICK = MICROS_PER_SECOND / TICKS_PER_SECOND;
const int SLEEP_THRESHOLD = 1_000;

class State {
	RenderState renderState;
	SimulationState simState;

	Widget[] widgets;

	private {
		double fps;

		static const MENU_BUTTON_SIZE = RenderCoords(150, 50);
	}

	this() {
		renderState = new RenderState();
		renderState.init();
		simState = new SimulationState();

		auto windowDims = renderState.windowDimensions;
		auto leftButton = new ButtonWidget(
			"red",
			MENU_BUTTON_SIZE,
			ClickFunction(function(State state, SDL_MouseButtonEvent) {
				state.simState.curNode = state.simState.curNode.left;
			})
		);
		leftButton.offset = RenderCoords(windowDims.x / 2, windowDims.y)
			- MENU_BUTTON_SIZE;
		widgets ~= leftButton;

		auto rightButton = new ButtonWidget(
			"green",
			MENU_BUTTON_SIZE,
			ClickFunction(function(State state, SDL_MouseButtonEvent) {
				state.simState.curNode = state.simState.curNode.right;
			}),
		);
		rightButton.offset = RenderCoords(
			windowDims.x / 2,
			windowDims.y - MENU_BUTTON_SIZE.y
		);
		widgets ~= rightButton;
	}

	void play() {
		while (simState.running) {
			// cap ticks-per-second
			auto mt = measureTime!((TickDuration duration) {
				fps = MICROS_PER_SECOND / (cast(double)duration.usecs);
				fps = min(fps, TICKS_PER_SECOND);

				auto usecsLeft = MICROS_PER_TICK - duration.usecs;
				if (usecsLeft > SLEEP_THRESHOLD) {
					Thread.sleep(dur!"usecs"(usecsLeft));
				}
			});

			// handle event queue
			SDL_Event event;
			while (SDL_PollEvent(&event) != 0) {
				handleEvent(event);
			}

			// update and render
			if (!simState.paused) {
				simState.update();
			}
			renderState.render(this);
		}
	}

	void show() {
		SDL_Event event;
		while (simState.running) {
			renderState.render(this);

			while (SDL_PollEvent(&event) != 0) {
				handleEvent(event);
			}
		}
	}

	void handleEvent(SDL_Event event) {
		switch (event.type) {
			case SDL_QUIT:
				simState.running = false;
				break;
			case SDL_KEYDOWN:
				handleKey(event.key.keysym.sym);
				break;
			case SDL_MOUSEBUTTONUP:
			case SDL_MOUSEBUTTONDOWN:
				handleClick(event.button);
				break;
			default:
				break;
		}
	}

	void handleKey(SDL_Keycode keycode) {
		auto renderState = renderState;
		switch (keycode) {
			case SDLK_q:
				// quit
				simState.running = false;
				break;

			case SDLK_p:
				// toggle pause
				simState.paused = !simState.paused;
				break;

			case SDLK_d:
				// toggle debug rendering
				renderState.debugRender = !renderState.debugRender;
				break;

			case SDLK_r:
				simState.generateGraph();
				break;

			default:
				break;
		}
	}

	void handleClick(SDL_MouseButtonEvent event) {
		foreach (widget; retro(widgets)) {
			if (widget.containsPoint(event)) {
				event.x -= widget.offset.x;
				event.y -= widget.offset.y;
				widget.handleClick(this, event);
				return;
			}
		}
	}
}
