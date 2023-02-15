class_name GridObject
extends Node2D

var grid_position = Vector2(0, 0) setget _set_grid_position
var size_in_grid = Vector2(1, 1) setget _set_size_in_grid

var is_grabbed = false setget _set_is_grabbed
var _position_valid = false 

var grid setget _set_grid

func _draw():
	if is_grabbed:
		if _position_valid:
			self.modulate = Color("#846680ff")
		else:
			self.modulate = Color("#85ff5442")
	else:
		self.modulate = Color("#ffffff")

func snap_to_grid(mouse_position):
	if grid == null: return
	var size_offset = _get_size_offset()
	_set_grid_position(grid.world_to_grid_position(mouse_position - size_offset)) 

func _set_is_grabbed(grabbed):
	is_grabbed = grabbed
	update()

func check_valid_position(valid):
	var tile_map = get_parent().get_node("Map")
	var collision = false
	for x in size_in_grid.x:
		for y in size_in_grid.y:
			collision = collision || tile_map.has_tile_collision(self.grid_position + Vector2(x, y))
	_position_valid = !collision
	update()

func _set_grid(g):
	grid = g
	if grid != null:
		update_grid_position_and_scale()

func _set_grid_position(p: Vector2):
	grid_position = p
	if grid != null:
		update_grid_position_and_scale()

func _set_size_in_grid(s: Vector2):
	size_in_grid = s
	if grid != null:
		update_grid_position_and_scale()
		update()

func update_grid_position_and_scale():
	var size_offset = _get_size_offset()
	position = grid.grid_to_world_position(grid_position) + size_offset
	
	var to_grid_scale = grid.cell_size / Vector2(64, 64)
	scale = to_grid_scale

func _get_size_offset():
	return (size_in_grid - Vector2(1, 1)) * grid.cell_size / 2

func _get_property_list():
	var properties = []
	
	properties.append({
		name = "Grip Options",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	properties.append({
		name = "grid_position",
		type = TYPE_VECTOR2
	})
	
	properties.append({
		name = "size_in_grid",
		type = TYPE_VECTOR2
	})
	
	return properties

func property_can_revert(property):
	if property == "size_in_grid":
		return true
	return false

func property_get_revert(property):
	if property == "size_in_grid":
		return Vector2(1, 1)
