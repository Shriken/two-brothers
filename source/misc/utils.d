module misc.utils;

NumType bound(NumType)(in NumType x, in NumType min, in NumType max) {
	if (x < min) return min;
	if (x > max) return max;
	return x;
}
