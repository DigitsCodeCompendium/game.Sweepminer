extends Node2D

signal found_bomb()
signal updated_flags_left(flags_left:int)
signal win_game(won:bool)
signal change_flag_button_state(state:bool)

# Create an array of 25 elements, initialized with default values (null)
var grid_values_secret = Array()
var grid_value_view = Array()
var grid_tiles = Array()

var tile_scene = preload("res://scenes//game//tile.tscn")

@export var num_bombs:int = 20
@export var width:int = 10
@export var height:int = 20

var num_bombs_found:int = 0;
var num_flags_used:int = 0;

var has_found_bomb :bool;
var first_click :bool;
var flag_mode :bool;

var tile_scale;
var screen_size;
var grid_size;
var offset;
var ui_height;

const TILE_SIZE = 16;

enum TileState {
	TILE = 9,
	FLAG = 10,
	BOMB = 11,
	ZERO = 0,
	ONE = 1,
	TWO = 2,
	THREE = 3,
	FOUR = 4,
	FIVE = 5,
	SIX = 6,
	SEVEN = 7,
	EIGHT = 8
}

var TileStateDict = {
	0: 'tile-0',
	1: 'tile-1',
	2: 'tile-2',
	3: 'tile-3',
	4: 'tile-4',
	5: 'tile-5',
	6: 'tile-6',
	7: 'tile-7',
	8: 'tile-8',
	9: 'tile',
	10: 'flag',
	11: 'bomb'
}

func _ready():
	screen_size = DisplayServer.window_get_size()
	tile_scale = float(screen_size.x-10*2) / float(TILE_SIZE * (width))
	
	grid_size = Vector2(width, height) * TILE_SIZE * tile_scale
	
	offset = Vector2(screen_size)/2 - grid_size/2
	
	position = offset
	
	for i in range(width * height):
		grid_values_secret.append(TileState.ZERO)
		grid_value_view.append(TileState.TILE)
	
	# Fill the array with 25 elements, initialized to 0
	for i in range(width * height):
		var tile = tile_scene.instantiate()
		tile.position = Vector2(((i % width)+0.5) * TILE_SIZE * tile_scale, 
								(floor(i / width)+0.5) * TILE_SIZE * tile_scale)
		tile.scale = Vector2(tile_scale, tile_scale)
		var tile_anim = TileStateDict.get(grid_values_secret[i])
		tile.play(tile_anim)
		tile.pos = i
		tile.connect("tile_clicked", _on_tile_clicked)
		
		add_child(tile)
		grid_tiles.append(tile)
		
	generate()

func _draw():
	draw_state(false)
	
	screen_size = DisplayServer.window_get_size()
	
	tile_scale = float(screen_size.x-10*2) / float(TILE_SIZE * (width))
	
	grid_size = Vector2(width, height) * TILE_SIZE * tile_scale
	
	offset = Vector2(screen_size)/2 - grid_size/2
	
	offset.y = ui_height
	
	position = offset

func draw_state(secret:bool):
	for i in range(width * height):
		if secret:
			grid_tiles[i].play(TileStateDict.get(grid_values_secret[i]))
		else:
			grid_tiles[i].play(TileStateDict.get(grid_value_view[i]))

func configure(package:StartGamePackage):
	num_bombs = package.number_of_bombs
	width = package.game_width
	height = package.game_height
	
func generate():
	first_click = true;
	num_bombs_found = 0;
	num_flags_used = 0;
	emit_signal("updated_flags_left", num_bombs)
	emit_signal("win_game", false)
	
	for i in range(width * height):
		grid_values_secret[i] = TileState.ZERO;
		grid_value_view[i] = TileState.TILE;
	
	randomize()
	var num_bombs_to_place = num_bombs
	while num_bombs_to_place > 0:
		var random_int = randi_range(0, (width * height)-1)
		if grid_values_secret[random_int] != TileState.BOMB:
			grid_values_secret[random_int] = TileState.BOMB
			
			# Check 8 surrounding locations
			for dx in [-1, 0, 1]:
				for dy in [-width, 0, width]:
					# Skip the center location (no need to modify itself)
					if dx == 0 and dy == 0:
						continue
					
					if random_int % width == width-1 and dx == 1:
						continue
					
					if random_int % width == 0 and dx == -1:
						continue
					
					var location = random_int + dx + dy
					# Check if the neighbor is within bounds and not 11
					if location >= 0 and location < width*height and grid_values_secret[location] != TileState.BOMB:
						grid_values_secret[location] += 1
				
			num_bombs_to_place -= 1

func _set_flag_mode(_flag_mode: bool):
	flag_mode = _flag_mode;

func _on_tile_clicked(pos:int,left:bool):
	#if the value is a tile
	if has_found_bomb:
		generate();
		draw_state(false);
		has_found_bomb = false;
		flag_mode = false;
		emit_signal("change_flag_button_state", false)
	
	elif flag_mode or not left: 
		if grid_value_view[pos] == TileState.TILE:
			grid_value_view[pos] = TileState.FLAG
			grid_tiles[pos].play(TileStateDict.get(grid_value_view[pos]))
			if grid_values_secret[pos] == TileState.BOMB:
				num_bombs_found += 1;
				if num_bombs_found == num_bombs:
					emit_signal("win_game", true)
					has_found_bomb = true;
			num_flags_used += 1;
			emit_signal("updated_flags_left", num_bombs - num_flags_used)
			
		elif grid_value_view[pos] == TileState.FLAG:
			grid_value_view[pos] = TileState.TILE
			grid_tiles[pos].play(TileStateDict.get(grid_value_view[pos]))
			if grid_values_secret[pos] == TileState.BOMB:
				num_bombs_found -= 1;
			num_flags_used -= 1;
			emit_signal("updated_flags_left", num_bombs - num_flags_used)
	
	else:
		if grid_value_view[pos] == TileState.TILE:
			#copy the secret value to the view value
			grid_value_view[pos] = grid_values_secret[pos]
			#update the tile to its new state
			grid_tiles[pos].play(TileStateDict.get(grid_value_view[pos]))
			
			if first_click:
				while grid_values_secret[pos] != TileState.ZERO:
					generate();
				first_click = false;
				flood_reveal(pos)
			
			#if the tile was a bomb, draw the whole screen and emit found bomb signal
			elif grid_values_secret[pos] == TileState.BOMB:
				found_bomb.emit()
				has_found_bomb = true;
				draw_state(true)
			
			elif grid_values_secret[pos] == TileState.ZERO:
				flood_reveal(pos)

func flood_reveal(first_pos):
	var searched = Array()
	var to_search = Array()
	
	#setup to_search with our first position to search
	to_search.append(first_pos)
	while not(to_search.is_empty()):
		var pos = to_search.pop_front()
		for dx in [-1, 0, 1]:
				for dy in [-width, 0, width]:
					# Skip the center location (no need to modify itself)
					if dx == 0 and dy == 0:
						continue
					
					if pos % width == width-1 and dx == 1:
						continue
					
					if pos % width == 0 and dx == -1:
						continue
						
					var search_pos = pos + dx + dy
					if search_pos >= 0 and search_pos < width*height and not(searched.has(search_pos)):
						if grid_values_secret[search_pos] == TileState.ZERO:
							to_search.append(search_pos)
						searched.append(search_pos)
	
	for pos in searched:
		grid_value_view[pos] = grid_values_secret[pos]
		grid_tiles[pos].play(TileStateDict.get(grid_value_view[pos]))


func _on_in_game_ui_ui_height(_ui_height):
	ui_height = _ui_height # Replace with function body.
