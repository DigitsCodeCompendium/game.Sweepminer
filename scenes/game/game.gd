extends Control

signal game_exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_game_exit():
	emit_signal('game_exit');

func configure(package:StartGamePackage):
	$MarginContainer/Grid.configure(package)
