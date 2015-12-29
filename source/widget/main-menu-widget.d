module widget.main_menu_widget;

import std.conv;
import gfm.math.vector;
import derelict.sdl2.sdl;

import misc.coords;
import state.state;
import widget.menu_widget;
import widget.button_widget;
import widget.display_widget;
import widget.options_menu_widget;
import widget.menu_opening_button_widget;
import widget.button_display_cluster_widget;

class MainMenuWidget : MenuWidget {
	this(RenderCoords offset, RenderCoords dimensions) {
		super(offset, dimensions);

		children ~= new ButtonDisplayClusterWidget(
			RenderCoords(200, 50),
			cast(ClickFunction)function(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				state.simState.curGenomeIndex--;
			},
			function(State state) {
				return (
					"Genome: " ~ to!string(state.simState.curGenomeIndex)
				);
			},
			cast(ClickFunction)function(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				state.simState.curGenomeIndex++;
			}
		);

		children ~= new MenuOpeningButtonWidget(
			"Options",
			RenderCoords(200, 50),
			new OptionsMenuWidget(offset, dimensions)
		);

		children ~= new ButtonWidget(
			"Back",
			RenderCoords(200, 50),
			cast(ClickFunction)function(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				state.ui.popMenu();
			}
		);

		children ~= new ButtonWidget(
			"Quit",
			RenderCoords(200, 50),
			cast(ClickFunction)function(
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
