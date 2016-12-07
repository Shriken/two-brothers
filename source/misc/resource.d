module misc.resources;

import std.path;

string BASE_PATH = ".";
string RESOURCE_PATH;

void setBasePath(string path) {
	BASE_PATH = path;
	RESOURCE_PATH = buildNormalizedPath(BASE_PATH, "res");
}

string getResourcePath(string resourceName) {
	return buildNormalizedPath(RESOURCE_PATH, resourceName);
}
