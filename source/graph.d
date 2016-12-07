import std.algorithm;
import std.format;

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
	}

	void setRight(Node other) {
		if (right !is null) right.refs--;
		right = other;
	}

	override string toString() {
		return format("%d: left=%d, right=%d, refs=%d", left, right, refs);
	}
}
