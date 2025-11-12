extends Control

@onready var main_container = get_node("%MainContainer")
@onready var start_container = get_node("%StartContainer")
@onready var custom_container = get_node("%CustomContainer")
@onready var settings_container = get_node("%SettingsContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_pressed():
	main_container.visible = false
	start_container.visible = true


func _on_cont_game_pressed():
	print("Lol that requires being able to save the game state")


func _on_settings_pressed():
	main_container.visible = false
	settings_container.visible = true


func _on_exit_pressed():
	get_tree().quit()

func _on_easy_pressed():
	print("Lol your assuming I know how to start the game scene")


func _on_normal_pressed():
	print("Lol your assuming I know how to start the game scene")


func _on_hard_pressed():
	print("Lol your assuming I know how to start the game scene")


func _on_custom_pressed():
	start_container.visible = false
	custom_container.visible = true


func _on_back_pressed():
	start_container.visible = false
	main_container.visible = true

func _on_start_pressed():
	print("Lol your assuming I know how to start the game scene")


func _on_custom_back_pressed():
	custom_container.visible = false
	start_container.visible = true


func _on_settings_back_pressed():
	settings_container.visible = false
	main_container.visible = true
