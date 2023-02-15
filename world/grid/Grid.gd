extends Area2D
class_name Grid
tool

signal mouse_grid_enter(grid)
signal mouse_grid_leave(grid)

export var size := Vector2(20, 20) setget _set_size
export var cell_size := Vector2(64, 64) setget _set_cell_size

func _ready():
	$CollisionShape2D.position = size * cell_size / 2
	$CollisionShape2D.shape.extents = size * cell_size / 2

func add_object(node, is_grabbed):
	if node is GridObject:
		node.grid = self
	if is_grabbed:
		$Cursor.grab_node(node)
	else:
		self.add_child(node)

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2.ZERO, size * cell_size), Color("#88888888"), false, 1)
		for x in size.x:
			for y in size.y:
				draw_rect(Rect2(Vector2(x, y) * cell_size, cell_size), Color("#88888888"), false, 0.2)

func grid_to_world_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + cell_size / 2

func world_to_grid_position(world_position: Vector2) -> Vector2:
	return clamp_to_grid((world_position / cell_size).floor())

func is_grid_pos_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

func is_world_pos_within_bounds(world_position: Vector2) -> bool:
	var out := world_position.x >= 0 and world_position.x < size.x * cell_size.x
	return out and world_position.y >= 0 and world_position.y < size.y * cell_size.y

func clamp_to_grid(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out

func get_world_size():
	return size * cell_size

func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)

func _set_size(s: Vector2):
	size = s
	update()
	
	for c in get_children():
		if c.has_method("update_grid_position_and_scale"):
			c.update_grid_position_and_scale()
	
	if Engine.editor_hint:
		$CollisionShape2D.position = size * cell_size / 2
		$CollisionShape2D.shape.extents = size * cell_size / 2
	
func _set_cell_size(cs: Vector2):
	cell_size = cs
	update()
	
	for c in get_children():
		if c.has_method("update_grid_position_and_scale"):
			c.update_grid_position_and_scale()
	
	if Engine.editor_hint:
		$CollisionShape2D.position = size * cell_size / 2
		$CollisionShape2D.shape.extents = size * cell_size / 2

func _on_Grid_mouse_entered():
	emit_signal("mouse_grid_enter", self)

func _on_Grid_mouse_exited():
	emit_signal("mouse_grid_leave", self)
