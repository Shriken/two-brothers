module state.sim_state;

import std.random;

import graph;
import misc.utils;

enum GenTechnique {
	ring,
	smart_random,
}

class SimulationState {
	static const int NUM_NODES = 5;

	bool running = true;
	bool paused = false;

	Graph graph;
	Node curNode;

	GenTechnique generation_technique = GenTechnique.smart_random;

	this(GenTechnique gen_technique=GenTechnique.ring) {
		generateGraph();
	}

	void generateGraph() {
		final switch (generation_technique) {
			case GenTechnique.ring:
				graph = generateGraphRing(NUM_NODES);
				break;
			case GenTechnique.smart_random:
				graph = generateGraphSmartRandom(NUM_NODES);
				break;
		}
		curNode = graph.nodes[0];
	}

	Graph generateGraphRing(int size) {
		Graph g = new Graph(size);
		foreach (i; 0 .. size) {
			g.nodes[i].setLeft( g.nodes[(i - 1).remainder(size)]);
			g.nodes[i].setRight(g.nodes[(i + 3).remainder(size)]);
		}
		return g;
	}

	Graph generateGraphSmartRandom(int size) {
		Graph g;
		g = new Graph(size);
		do {
			foreach (node; g.nodes) {
				do node.left = g.nodes[uniform(0, size)];
				while (node is node.left);
			}

			if (g.isConnected()) continue;

			foreach (node; g.nodes) {
				do node.right = g.nodes[uniform(0, size)];
				while (node is node.right);
			}
		} while (!g.isConnected());
		return g;
	}

	void update() {}
}
