module misc.color;

struct Color {
	ubyte r;
	ubyte g;
	ubyte b;

	this(byte r, byte g, byte b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}

	this(int r, int g, int b) {
		this.r = cast(ubyte)r;
		this.g = cast(ubyte)g;
		this.b = cast(ubyte)b;
	}
};
