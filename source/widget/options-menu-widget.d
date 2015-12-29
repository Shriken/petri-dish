module widget.options_menu_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import state.state;
import widget.button_widget;
import widget.menu_widget;

class OptionsMenuWidget : MenuWidget {
	this(vec2i offset, vec2i dimensions) {
		super(offset, dimensions);

		children ~= new ButtonWidget(
			"Back",
			vec2i(200, 50),
			cast(ClickFunction)function(
				ButtonWidget thisWidget,
				State state,
				SDL_MouseButtonEvent event
			) {
				state.ui.popMenu();
			}
		);

		updatePosition(offset, dimensions);
	}
}
