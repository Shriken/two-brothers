module state.render_state;

import std.stdio;

import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import gfm.math.vector;

import misc.coords;
import misc.rect;
import misc.resources;
import render_utils;
import state.state;

const SDL_Color WHITE = SDL_Color(0xff, 0xff, 0xff, 0xff);
const SDL_Color RED = SDL_Color(0xff, 0x00, 0x00, 0xff);
const SDL_Color GREEN = SDL_Color(0x00, 0xff, 0x00, 0xff);
const SDL_Color HIGHLIGHT = SDL_Color(0x20, 0x60, 0xff, 0xff);

class RenderState {
	RenderCoords windowDimensions = RenderCoords(1240, 800);
	SDL_Window *window = null;
	SDL_Renderer *renderer = null;

	bool debugRender = true;
	TTF_Font *debugTextFont;
	TTF_Font *buttonFont;
	double scale = 1;

	void render(State state) {
		auto simState = state.simState;

		// clear screen
		SDL_RenderSetViewport(renderer, null);
		this.renderClear();

		// draw nodes
		foreach (node; simState.graph.nodes) {
			node.render(state, WHITE);
		}
		simState.curNode.render(state, HIGHLIGHT, false);

		// draw widgets
		foreach (widget; state.widgets) {
			auto clipRect = getRectFromVectors(
				widget.offset,
				widget.offset + widget.dimensions
			);
			SDL_RenderSetViewport(renderer, &clipRect);
			widget.render(state);
		}

		SDL_RenderPresent(renderer);
	}

	bool init() {
		// set up SDL
		DerelictSDL2.load();
		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
			writeln("failed to init sdl video");
			return false;
		}

		// create the game window
		window = SDL_CreateWindow(
			"Two Brothers",
			SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED,
			windowDimensions.x,
			windowDimensions.y,
			SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
		);
		if (window is null) {
			return false;
		}

		// determine the scale we're working at
		int x, y;
		SDL_GL_GetDrawableSize(window, &x, &y);
		auto xScale = 1. * x / windowDimensions.x;
		auto yScale = 1. * y / windowDimensions.y;
		assert(xScale == yScale);
		scale = xScale;

		// initialize the renderer
		renderer = SDL_CreateRenderer(window, -1, 0);
		SDL_RenderSetScale(renderer, scale, scale);
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);

		// set up sdl_ttf
		DerelictSDL2ttf.load();
		if (TTF_Init() != 0) {
			writeln("failed to init ttf");
			return false;
		}

		// load the fonts
		debugTextFont = TTF_OpenFont(
			getResourcePath("monaco.ttf").dup.ptr,
			10
		);
		if (debugTextFont is null) {
			writeln("font not present");
			return false;
		}

		buttonFont = TTF_OpenFont(
			getResourcePath("monaco.ttf").dup.ptr,
			15
		);
		if (debugTextFont is null) {
			writeln("font not present");
			return false;
		}

		return true;
	}

	~this() {
		SDL_DestroyRenderer(renderer);
		SDL_DestroyWindow(window);
		SDL_Quit();
	}
}
