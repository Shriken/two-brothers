module misc.utils;

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
