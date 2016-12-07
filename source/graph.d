import std.algorithm;
import std.format;
import std.math;

import derelict.sdl2.sdl;

import misc.coords;
import misc.utils;
import render_utils;
import state.state;

class Graph {
	Node[] nodes;

	this(const int size) {
		nodes.length = size;
		foreach (i; 0 .. size) {
			nodes[i] = new Node(i);
		}
	}

	override string toString() {
		return nodes
			.map!(n => n.toString())
			.fold!((a,b) => a ~ "\n" ~ b);
	}
}

class Node {
	Node left;
	Node right;
	int index;
	int refs;

	this(int index) {
		this.index = index;
	}

	void setLeft(Node other) {
		if (left !is null) left.refs--;
		left = other;
		left.refs++;
	}

	void setRight(Node other) {
		if (right !is null) right.refs--;
		right = other;
		left.refs++;
	}

	override string toString() {
		return format("%d: left=%d, right=%d, refs=%d", left, right, refs);
	}

	RenderCoords getRenderPos(State state,) {
		auto renderState = state.renderState;
		auto center = renderState.windowDimensions / 2;
		auto theta = PI * 1.5
			- 2*PI * index / state.simState.graph.nodes.length;

		return center + RenderCoords(
			cast(int) (RAD * cos(theta)),
			cast(int) (RAD * sin(theta))
		);
	}

	static const int RAD = 200;
	static const RenderCoords RECT_DIMS = RenderCoords(10, 10);
	static const RenderCoords HEAD_DIMS = RenderCoords(6, 6);
	void render(State state, SDL_Color color) {
		auto renderPos = getRenderPos(state);
		state.renderState.fillRect(
			renderPos - RECT_DIMS / 2,
			RECT_DIMS,
			color, 0xff
		);

		// left arrow
		auto leftPos = left.getRenderPos(state);
		state.renderState.drawLine(renderPos, leftPos, WHITE, 0xff);
		auto leftHeadPos = lerp(renderPos, leftPos, 0.9);
		state.renderState.fillRect(
			leftHeadPos - HEAD_DIMS / 2,
			HEAD_DIMS,
			WHITE, 0xff
		);

		// right arrow
		auto rightPos = right.getRenderPos(state);
		state.renderState.drawLine(renderPos, rightPos, WHITE, 0xff);
		auto rightHeadPos = lerp(renderPos, rightPos, 0.9);
		state.renderState.fillRect(
			rightHeadPos - HEAD_DIMS / 2,
			HEAD_DIMS,
			WHITE, 0xff
		);
	}
}
