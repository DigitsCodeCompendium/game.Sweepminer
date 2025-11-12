extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.connect('start_game', _on_game_start)
	$Game.connect('end_game', _on_game_end)

func _on_game_start(package:StartGamePackage):
	$MainMenu.visible = false
	$Game.visible = true

func _on_game_end(won:bool):
	$MainMenu.visible = true
	$Game.visible = false
	$MainMenu.reset_menu();
