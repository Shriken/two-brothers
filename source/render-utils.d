module render_utils;

import std.conv;
import std.stdio;
import gfm.math.vector;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import misc.rect;
import misc.coords;
import state.render_state;

const auto BLACK = SDL_Color(0, 0, 0, 0);
const auto WHITE = SDL_Color(0xff, 0xff, 0xff, 0xff);

void setDrawColor(
	SDL_Renderer *renderer,
	SDL_Color color,
	ubyte alpha
) {
	SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, alpha);
}

void renderClear(RenderState state) {
	SDL_SetRenderDrawColor(state.renderer, 0, 0, 0, 0xff);
	SDL_RenderClear(state.renderer);
}

void drawText(
	RenderState state,
	string text,
	TTF_Font *font,
	int x,
	int y
) {
	state.drawText(text.dup ~ '\0', font, x, y);
}

void drawText(
	RenderState state,
	char[] text,
	TTF_Font *font,
	int x,
	int y
) {
	auto textTexture = state.getTextTexture(text, font, WHITE);
	if (textTexture is null) {
		writeln(to!string(SDL_GetError()));
		return;
	}

	int w, h;
	SDL_QueryTexture(textTexture, null, null, &w, &h);
	auto targetLoc = SDL_Rect(x, y, w, h);
	SDL_RenderCopy(state.renderer, textTexture, null, &targetLoc);
	SDL_DestroyTexture(textTexture);
}

void drawTextCentered(
	RenderState state,
	string text,
	TTF_Font *font,
	int x,
	int y
) {
	state.drawTextCentered(text.dup ~ '\0', font, x, y);
}

void drawTextCentered(
	RenderState state,
	char[] text,
	TTF_Font *font,
	int x,
	int y
) {
	auto textTexture = state.getTextTexture(text, font, WHITE);
	if (textTexture is null) {
		writeln(to!string(SDL_GetError()));
		return;
	}

	int w, h;
	SDL_QueryTexture(textTexture, null, null, &w, &h);
	auto targetLoc = SDL_Rect(x - w / 2, y - h / 2, w, h);
	SDL_RenderCopy(state.renderer, textTexture, null, &targetLoc);
	SDL_DestroyTexture(textTexture);
}

SDL_Texture *getTextTexture(
	RenderState state,
	char[] text,
	TTF_Font *font,
	SDL_Color color
) {
	auto textSurface = TTF_RenderText_Solid(font, text.ptr, color);
	if (textSurface is null) {
		writeln(to!string(SDL_GetError()));
		return null;
	}
	scope(exit) SDL_FreeSurface(textSurface);

	auto textTexture = SDL_CreateTextureFromSurface(
		state.renderer,
		textSurface
	);
	if (textTexture is null) {
		writeln(to!string(SDL_GetError()));
		return null;
	}

	return textTexture;
}

void drawRect(
	RenderState state,
	RenderCoords topLeft,
	RenderCoords dimensions,
	SDL_Color color,
	ubyte alpha,
) {
	auto targetRect = getRectFromVectors(
		topLeft,
		topLeft + dimensions
	);
	setDrawColor(state.renderer, color, alpha);
	SDL_RenderDrawRect(state.renderer, &targetRect);
}

void fillRect(
	RenderState state,
	RenderCoords topLeft,
	RenderCoords dimensions,
	SDL_Color color,
	ubyte alpha,
) {
	auto targetRect = getRectFromVectors(
		topLeft,
		topLeft + dimensions
	);
	setDrawColor(state.renderer, color, alpha);
	SDL_RenderFillRect(state.renderer, &targetRect);
}

void drawLine(
	RenderState state,
	RenderCoords point1,
	RenderCoords point2,
	SDL_Color color,
	ubyte alpha,
) {
	setDrawColor(state.renderer, color, alpha);
	SDL_RenderDrawLine(
		state.renderer,
		cast(int)point1.x,
		cast(int)point1.y,
		cast(int)point2.x,
		cast(int)point2.y
	);
}
