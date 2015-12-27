module widget.main_menu_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import state.state;
import widget.button_widget;
import widget.menu_widget;
import widget.menu_button_widget;

class MainMenuWidget : MenuWidget {
	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);

		children ~= new MenuButtonWidget(
			"Options",
			new MenuWidget(offset, dimensions)
		);

		children ~= new ButtonWidget(
			"Quit",
			delegate(State state, SDL_MouseButtonEvent event) {
				state.simState.running = false;
			}
		);

		updatePosition(offset, dimensions);
	}
}
