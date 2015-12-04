module genome;

import std.stdio;
import std.string;
import std.algorithm;

import misc.color;

/+
 + Genomes hold the rules which define the behavior of an organism.
 + They can be edited by virocytes, or by the player.
 +/

class Genome {
	CellMode[] cellModes;

	this() {
		foreach (i; 0 .. 16) {
			cellModes ~= CellMode();
		}
	}
};

enum CellType {
	phagocyte,
	flagellocyte,
	photocyte,
	devorocyte,
	lipocyte,
	keratinocyte,
	buoyocyte,
	glueocyte,
	virocyte,
	nitrocyte
};

struct CellMode {
	CellType cellType;

	bool makeAdhesin = false;
	double nutrientPriority;
	double splitThreshold = 2.5;
	double splitRatio = 1;
	double splitAngle;

	double child1Rotation;
	byte child1Mode; // 0 - 15
	bool child1KeepAdhesin;

	double child2Rotation;
	byte child2Mode; // 0 - 15
	bool child2KeepAdhesin;

	Color color;
};

void save(Genome genome, string filename) {
	File(filename, "w").print(genome);
}

void print(File file, Genome genome) {
	file.writeln("numModes: ", genome.cellModes.length);
	file.writeln();

	foreach (mode; genome.cellModes) {
		file.writeln("cellType: ", mode.cellType);

		file.writeln("makeAdhesin: ", mode.makeAdhesin);
		file.writeln("nutrientPriority: ", mode.nutrientPriority);
		file.writeln("splitThreshold: ", mode.splitThreshold);
		file.writeln("splitRatio: ", mode.splitRatio);
		file.writeln("splitAngle: ", mode.splitAngle);

		file.writeln("child1Rotation: ", mode.child1Rotation);
		file.writeln("child1Mode: ", mode.child1Mode);
		file.writeln("child1KeepAdhesin: ", mode.child1KeepAdhesin);

		file.writeln("child2Rotation: ", mode.child2Rotation);
		file.writeln("child2Mode: ", mode.child2Mode);
		file.writeln("child2KeepAdhesin: ", mode.child2KeepAdhesin);

		file.writeln("color: ", mode.color);
		file.writeln();
	}
}
