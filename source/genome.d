module genome;

import misc.color;

/+
 + Genomes hold the rules which define the behavior of an organism.
 + They can be edited by virocytes, or by the player.
 +/

class Genome {
	CellMode[16] cellModes;
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
	bool makeAdhesin = false;
	CellType cellType;

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
