module consts;

import std.path;

// path to parent directory of executable
string BASE_PATH;
string RES_PATH;

void setBasePath(string path) {
	BASE_PATH = path;
	RES_PATH = buildNormalizedPath(BASE_PATH, "res");
}
