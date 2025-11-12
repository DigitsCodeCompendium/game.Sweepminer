class_name StartGamePackageBuilder
extends RefCounted

var package: StartGamePackage

func _init():
	self.package = StartGamePackage.new()

func start_new():
	self.package = StartGamePackage.new()
	return self

func easy():
	package.number_of_bombs = 40;
	package.game_height = 20;
	package.game_width = 10
	return self

func medium():
	package.number_of_bombs = 80;
	package.game_height = 22;
	package.game_width = 12
	return self

func hard():
	package.number_of_bombs = 80;
	package.game_height = 22;
	package.game_width = 12
	return self

func set_game_height(height:int):
	package.game_height = height;
	return self

func set_game_width(width:int):
	package.game_width = width;
	return self

func set_game_size(height:int, width:int):
	package.game_height = height;
	package.game_width = width;
	return self

func set_game_size_vec2(size:Vector2):
	package.game_height = size.x;
	package.game_width = size.y;
	return self

func set_num_bombs(num:int):
	package.number_of_bombs = num;
	return self

func get_result():
	return package
