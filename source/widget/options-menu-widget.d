module widget.options_menu_widget;

import gfm.math.vector;
import derelict.sdl2.sdl;

import misc.coords;
import state.state;
import widget.button_widget;
import widget.menu_widget;

const RenderCoords MENU_BUTTON_SIZE = RenderCoords(200, 35);

class OptionsMenuWidget : MenuWidget {
	this(RenderCoords offset, RenderCoords dimensions) {
		super(offset, dimensions);

		children ~= new ButtonWidget(
			"Back",
			MENU_BUTTON_SIZE,
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
