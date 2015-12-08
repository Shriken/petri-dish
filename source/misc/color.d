module misc.color;

struct Color {
	byte r;
	byte g;
	byte b;

	this(byte r, byte g, byte b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}

	this(int r, int g, int b) {
		this.r = cast(byte)r;
		this.g = cast(byte)g;
		this.b = cast(byte)b;
	}
};
