module misc.utils;

import misc.coords;

NumType clamp(NumType)(in NumType x, in NumType min, in NumType max) {
	if (x < min) return min;
	if (x > max) return max;
	return x;
}

Num remainder(Num)(in Num x, in Num y) {
	Num rem = x % y;
	if (rem < 0) rem += y;
	return rem;
}

RenderCoords lerp(in RenderCoords x, in RenderCoords y, real param) {
	return RenderCoords(
		cast(int) (y.x * param + x.x * (1 - param)),
		cast(int) (y.y * param + x.y * (1 - param)),
	);
}

class Stack(T) {
	private T[] data = new T[100];
	private size_t _length = 0;

	void push(T t) {
		_length++;
		if (length > data.length) {
		}
	}
}
