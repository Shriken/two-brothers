module state.render_state;

import std.stdio;
import std.stdio;

import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import gfm.math.vector;

import misc.coords;
import misc.resources;
import state.sim_state;

class RenderState {
	RenderCoords windowDimensions = RenderCoords(1240, 800);
	SDL_Window *window = null;
	SDL_Renderer *renderer = null;

	bool debugRender = true;
	TTF_Font *debugTextFont;
	TTF_Font *buttonFont;
	double scale = 1;

	void render(SimulationState simState) {}

	bool init() {
		// set up SDL
		DerelictSDL2.load();
		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
			writeln("failed to init sdl video");
			return false;
		}

		// create the game window
		window = SDL_CreateWindow(
			"Petri dish",
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
