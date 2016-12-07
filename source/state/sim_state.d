module state.sim_state;

import std.stdio;

import graph;
import misc.utils;

class SimulationState {
	static const int NUM_NODES = 10;

	bool running = true;
	bool paused = false;

	Graph graph;
	Node[] graphNodes;

	this() {
		graph = generateGraph(NUM_NODES);
	}

	Graph generateGraph(int size) {
		Graph g = new Graph(size);
		foreach (i; 0 .. size) {
			g.nodes[i].setLeft( g.nodes[(i - 1).remainder(size)]);
			g.nodes[i].setRight(g.nodes[(i + 1).remainder(size)]);
		}

		return g;
	}

	void update() {}
}
