extends Control

signal flag_button_toggled(new_state:bool)
signal victory_pressed()
signal ui_height(height:int)

signal replay()
signal game_exit()

@onready var ui_size = get_node("HudContainer").size
@onready var flags_label = get_node("%RemainingFlags")
@onready var flag_button = get_node("%FlagModeButton")
@onready var end_screen = get_node("%EndScreenContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	flag_button.connect("flag_button_toggled", _emit_flag_button_toggled)
	emit_signal("ui_height",ui_size.y)
	
func _update_flags_left(flags_left:int):
	flags_label.text = str(flags_left);

func _emit_flag_button_toggled(new_state:bool):
	emit_signal("flag_button_toggled", new_state)
	
func _set_flag_mode_button(state:bool):
	flag_button.set_toggle_state(state);

func _on_grid_found_bomb():
	end_screen.visible = false; # Replace with function body.
	
	
func _on_exit_pressed():
	emit_signal("game_exit")
func _on_replay_pressed():
	emit_signal("replay") # Replace with function body.
	end_screen.visible = false

func _on_grid_win_game(won):
	end_screen.visible = true;
	end_screen.get_node("%VictoryContainer").visible = won
	end_screen.get_node("%LoseContainer").visible = !won

