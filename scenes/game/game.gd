extends Control

signal end_game(won:bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Grid.connect('win_game', _on_game_win)
	$MarginContainer/Grid.connect('found_bomb', _on_game_lose)

func _on_game_win():
	emit_signal('end_game', true)
	
func _on_game_lose():
	emit_signal('end_game', false)
