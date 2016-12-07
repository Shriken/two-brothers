import std.path;
import std.stdio;

import misc.resources;
import state.state;

void main(string[] args) {
	setBasePath(buildNormalizedPath(args[0], ".."));

	try {
		auto state = new State();
		//state.play();
		state.show();
	} catch (Exception e) {
		writefln("%s", e.msg);
	}
}
