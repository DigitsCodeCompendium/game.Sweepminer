extends Button

@export var button_off:Texture2D;
@export var button_on:Texture2D;

signal flag_button_toggled(new_state:bool)

var toggle_state

func update_icon_state():
	if toggle_state:
		self.icon = button_on;
	else:
		self.icon = button_off;

func _pressed():
	toggle_state = not(toggle_state);
	emit_signal("flag_button_toggled", toggle_state);
	
	update_icon_state();

func set_toggle_state(state:bool):
	toggle_state = state;
	update_icon_state();
