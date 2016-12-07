module state.sim_state;

import graph;
import misc.utils;

enum GenerationTechnique {
	ring,
	smart_random,
}

class SimulationState {
	static const int NUM_NODES = 10;

	bool running = true;
	bool paused = false;

	Graph graph;
	Node curNode;

	GenerationTechnique generation_technique;

	this(GenerationTechnique gen_technique=GenerationTechnique.ring) {
		graph = generateGraph(NUM_NODES);
		curNode = graph.nodes[0];
		import std.stdio;
		writeln("graph connected: ", graph.isConnected());
	}

	Graph generateGraph(int size) {
		switch (generation_technique) {
			case GenerationTechnique.ring:
				return generateGraphRing(size);
			case GenerationTechnique.smart_random:
				return generateGraphSmartRandom(size);
			default:
				return null;
		}
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
		return null;
	}

	void update() {}
}
