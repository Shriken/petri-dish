module widget.main_menu_widget;

import std.conv;
import gfm.math.vector;
import derelict.sdl2.sdl;

import state.state;
import widget.menu_widget;
import widget.button_widget;
import widget.display_widget;
import widget.options_menu_widget;
import widget.menu_opening_button_widget;

class MainMenuWidget : MenuWidget {
	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);

		children ~= new ButtonWidget(
			"<    >",
			delegate(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				auto simState = state.simState;
				if (
					event.x < thisWidget.dimensions.x / 2 &&
					simState.curGenomeIndex > 0
				) {
					simState.curGenomeIndex--;
				} else if (
					event.x > thisWidget.dimensions.x / 2 &&
					simState.curGenomeIndex < simState.genomes.length - 1
				) {
					simState.curGenomeIndex++;
				}
			}
		);

		children ~= new DisplayWidget(
			delegate(State state) {
				return (
					"Genome: " ~ to!string(state.simState.curGenomeIndex)
				);
			}
		);

		children ~= new MenuOpeningButtonWidget(
			"Options",
			new OptionsMenuWidget(offset, dimensions)
		);

		children ~= new ButtonWidget(
			"Back",
			delegate(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				state.ui.popMenu();
			}
		);

		children ~= new ButtonWidget(
			"Quit",
			delegate(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				state.simState.running = false;
			}
		);

		updatePosition(offset, dimensions);
	}
}
