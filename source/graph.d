import std.algorithm;
import std.format;
import std.math;

import derelict.sdl2.sdl;

import misc.coords;
import misc.utils;
import render_utils;
import state.state;
import state.render_state;

class Graph {
	Node[] nodes;

	this(const int size) {
		nodes.length = size;
		foreach (i; 0 .. size) {
			nodes[i] = new Node(i);
		}
	}

	bool isConnected() {
		foreach (u; 0 .. nodes.length) {
			auto toVisit = [nodes[u]];
			auto visited = new bool[nodes.length];
			while (toVisit.length > 0) {
				auto curNode = toVisit[$-1];
				toVisit.length--;
				if (visited[curNode.index]) continue;
				visited[curNode.index] = true;
				toVisit ~= [curNode.left, curNode.right];
			}

			foreach (v; visited) {
				if (!v) return false;
			}
		}

		return true;
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
		this.left = this;
		this.right = this;
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

	RenderCoords getRenderPos(State state) {
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
	void render(State state, SDL_Color color, bool drawEdges=true) {
		auto renderPos = getRenderPos(state);

		if (drawEdges) {
			// left arrow
			{
				auto leftPos = left.getRenderPos(state);
				state.renderState.drawLine(
					renderPos, leftPos,
					RED, 0xff
				);
				auto length = sqrt(cast(real) renderPos.squaredDistanceTo(leftPos));
				auto lerpParam = (length - HEAD_DIMS.x * 4) / length;
				auto headPos = lerp(renderPos, leftPos, lerpParam);
				state.renderState.fillRect(
					headPos - HEAD_DIMS / 2,
					HEAD_DIMS,
					RED, 0xff
				);
			}

			// right arrow
			{
				auto rightPos = right.getRenderPos(state);
				state.renderState.drawLine(
					renderPos, rightPos,
					GREEN, 0xff
				);
				auto length = sqrt(cast(real) renderPos.squaredDistanceTo(rightPos));
				auto lerpParam = (length - HEAD_DIMS.x * 4) / length;
				auto headPos = lerp(renderPos, rightPos, lerpParam);
				state.renderState.fillRect(
					headPos - HEAD_DIMS / 2,
					HEAD_DIMS,
					GREEN, 0xff
				);
			}
		}

		state.renderState.fillRect(
			renderPos - RECT_DIMS / 2,
			RECT_DIMS,
			color, 0xff
		);
	}
}
