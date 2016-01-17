module actor.cell;

import std.math;
import std.range;
import std.stdio;
import std.random;
import std.algorithm;
import gfm.math.vector;
import derelict.sdl2.sdl;

import consts;
import genome;
import misc.coords;
import state.render_state;
import widget.experiment_render_utils;

struct Adhesion {
	// angle of adhesion with respect to owner's heading
	double relativeAngle;
	Cell cell;
}

class Cell {
	static const double RAD_PER_MASS = 2;
	static const double MIN_MASS = 0.65;
	static const double MAX_MASS = 3.55;
	static const double DEVOROCYTE_CONSUMPTION_RATE = 0.3;

	WorldCoords pos;
	WorldCoords vel;
	double mass = 2;
	double heading = 0;
	CellMode *mode;
	Genome genome;

	Adhesion[] adhesions;

	// state variables for use in update
	bool shouldDie = false;
	double massChange = 0;
	double headingChange = 0;

	@disable this();

	this(Cell cell) {
		this.pos = cell.pos;
		this.vel = cell.vel;
		this.mass = cell.mass;
		this.heading = cell.heading;
		this.mode = cell.mode;
		this.genome = cell.genome;
		this.adhesions = cell.adhesions.dup;
	}

	this(WorldCoords pos, Genome genome, CellMode *mode) {
		this.genome = genome;
		this.mode = mode;
		this.pos = pos;
		this.vel = WorldCoords(0, 0);
		this.heading = uniform(0, 2 * PI);
	}

	void render(ref ExperimentRenderState state) {
		// draw body
		state.fillRect(
			pos - WorldCoords(rad, rad),
			WorldCoords(rad * 2, rad * 2),
			mode.color,
			0xff
		);

		// draw center
		state.fillRect(
			pos - WorldCoords(rad / 4, rad / 4),
			WorldCoords(rad / 2, rad / 2),
			SDL_Color(0, 0, 0),
			0xff
		);

		// draw eye
		auto eyeOffset = WorldCoords(
			cos(heading) * rad / 2,
			sin(heading) * rad / 2
		);
		state.fillRect(
			pos - WorldCoords(rad / 4, rad / 4) + eyeOffset,
			WorldCoords(rad / 2, rad / 2),
			SDL_Color(0, 0, 0),
			0xff
		);

		// draw adhesin bonds
		foreach (adhesion; adhesions) {
			auto bondEyeOffset = WorldCoords(
				cos(heading + adhesion.relativeAngle) * rad / 2,
				sin(heading + adhesion.relativeAngle) * rad / 2
			);
			state.fillRect(
				pos - WorldCoords(rad / 4, rad / 4) + bondEyeOffset,
				WorldCoords(rad / 2, rad / 2),
				SDL_Color(0xff, 0, 0),
				0xff
			);
			state.drawLine(
				pos,
				adhesion.cell.pos,
				SDL_Color(0xff, 0, 0),
				0xff
			);
		}
	}

	Cell reproduce() {
		auto oldMode = mode;
		massChange -= mass / 2;

		auto worldSplitAngle = heading + oldMode.splitAngle;

		// child 2
		Cell newCell = new Cell(this);
		newCell.vel.x -= cos(worldSplitAngle);
		newCell.vel.y -= sin(worldSplitAngle);
		newCell.heading = (worldSplitAngle + oldMode.child2Rotation) %
			2 * PI;
		newCell.mode = &genome.cellModes[oldMode.child2Mode];
		newCell.mass /= 2;

		// no one should be bound to the new cell yet
		assert(!any!(cell => cell.isBoundTo(newCell))(
			newCell.adhesedCells
		));

		if (oldMode.child2KeepAdhesin) {
			// clone all the parent's adhesions
			foreach (cell; newCell.adhesedCells) {
				cell.adheseWith(
					newCell,
					cell.angleTo(newCell) - cell.heading
				);
			}
		} else {
			// remove any old adhesions
			newCell.adhesions.destroy();
		}

		// child 1
		vel.x += cos(heading + oldMode.splitAngle);
		vel.y += sin(heading + oldMode.splitAngle);
		heading = (
			heading + oldMode.splitAngle + oldMode.child1Rotation
		) % 2 * PI;
		mode = &genome.cellModes[oldMode.child1Mode];
		if (!oldMode.child1KeepAdhesin) {
			// unbind
			foreach (cell; this.adhesedCells) {
				cell.unadheseWith(this);
			}
			adhesions.destroy();

			assert(!any!(cell => cell.isBoundTo(this))(
				this.adhesedCells
			));
		}

		// make adhesin if necessary
		if (oldMode.makeAdhesin) {
			this.adheseWith(newCell, PI + worldSplitAngle - heading);
			newCell.adheseWith(
				this,
				worldSplitAngle - newCell.heading
			);
		}

		return newCell;
	}

	void die() {
		foreach (cell; this.adhesedCells) {
			cell.unadheseWith(this);
		}
		adhesions.destroy();
	}

	void gainMass(double amount) {
		mass += amount;
		if (mass > Cell.MAX_MASS) {
			mass = Cell.MAX_MASS;
		}
	}

	double rad() {
		return mass * Cell.RAD_PER_MASS;
	}

	double massConsumption() {
		if (mode.cellType is CellType.flagellocyte) {
			return 0.003;
		}

		return 0.002;
	}

	void collide(Cell otherCell) {
		// check and handle actual collisions
		auto posDiff = pos - otherCell.pos;
		auto radSum = rad + otherCell.rad;
		auto diffSquared = posDiff.squaredLength();
		if (diffSquared < radSum ^^ 2) {
			vel += posDiff / diffSquared;

			if (
				mode.cellType is CellType.devorocyte &&
				otherCell.mode.cellType !is CellType.devorocyte
			) {
				// eat other cell
				massChange += DEVOROCYTE_CONSUMPTION_RATE;
				otherCell.massChange -= DEVOROCYTE_CONSUMPTION_RATE;
			}
		}
	}
};

void updatePos(Cell cell) {
	// update position
	cell.pos += cell.vel;

	// simulate viscosity
	cell.vel *= VISCOSITY_SLOWING_FACTOR;

	foreach (adhesion; cell.adhesions) {
		auto adhesedCell = adhesion.cell;

		// linear spring
		auto posDiff = adhesedCell.pos - cell.pos;
		auto radSum = cell.rad + adhesedCell.rad;
		auto squaredDist = posDiff.squaredLength;
		if (squaredDist > radSum ^^ 2) {
			cell.vel += posDiff * 0.03;
		}

		// rotary spring
		auto bondAngle = cell.heading + adhesion.relativeAngle;
		auto realAngle = atan2(posDiff.y, posDiff.x);
		cell.heading += ((bondAngle - realAngle) % (2 * PI)) * 0.01;
		cell.heading %= 2 * PI;
		if (cell.heading > PI) {
			cell.heading -= 2 * PI;
		}

		// rotary spring: translational part
	}
}

void adheseWith(Cell cell, Cell otherCell, double adhesionAngle) {
	cell.adhesions ~= Adhesion(adhesionAngle, otherCell);
}

void unadheseWith(Cell cell, Cell otherCell) {
	size_t index;
	for (index = 0; index < cell.adhesions.length; index++) {
		if (cell.adhesions[index].cell is otherCell) {
			break;
		}
	}

	cell.adhesions = cell.adhesions.remove!(SwapStrategy.unstable)(
		index
	);
}

bool isBoundTo(Cell cell, Cell otherCell) {
	return any!(adhesion => adhesion.cell is otherCell)(cell.adhesions);
}

double angleTo(Cell cell, Cell otherCell) {
	auto posDiff = otherCell.pos - cell.pos;
	return atan2(posDiff.y, posDiff.x);
}

struct AdhesionRange {
	Adhesion[] adhesions;

	this(Adhesion[] adhesions) {
		this.adhesions = adhesions;
	}

	@property bool empty() {
		return adhesions.length == 0;
	}

	@property Cell front() {
		return adhesions[0].cell;
	}

	@property void popFront() {
		adhesions = adhesions[1 .. $];
	}
}

AdhesionRange adhesedCells(Cell cell) {
	return AdhesionRange(cell.adhesions);
}
