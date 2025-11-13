extends Control

@onready var game_preload = preload("res://scenes/game/main.tscn")
var game_instance;

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.connect('start_game', _on_game_start)

func _on_game_start(package:StartGamePackage):
	$MainMenu.visible = false
	game_instance = game_preload.instantiate()
	game_instance.configure(package)
	game_instance.connect("game_exit", _on_game_exit)
	add_child(game_instance)
	
func _on_game_exit():
	$MainMenu.visible = true
	game_instance.queue_free()
	$MainMenu.reset_menu();
