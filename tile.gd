extends AnimatedSprite2D

signal tile_clicked(pos:int)

var pos:int = 0

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				emit_signal("tile_clicked", pos)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				emit_signal("tile_clicked", pos)
