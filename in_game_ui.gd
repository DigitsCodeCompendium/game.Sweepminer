extends Control

signal flag_button_toggled(new_state:bool)
signal victory_pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/MarginContainer2/MarginContainer/HBoxContainer/Button.connect("flag_button_toggled", _emit_flag_button_toggled)
	
func _update_flags_left(flags_left:int):
	$VBoxContainer/MarginContainer2/MarginContainer/HBoxContainer/Label.text = str(flags_left);

func _emit_flag_button_toggled(new_state:bool):
	emit_signal("flag_button_toggled", new_state)

func _show_victory_screen(show:bool):
	$VBoxContainer/MarginContainer.visible = show;

func _set_flag_mode_button(state:bool):
	$VBoxContainer/MarginContainer2/MarginContainer/HBoxContainer/Button.set_toggle_state(state);
