extends Node2D

var grabbed_node: Node2D
var is_in_grid := false

func _draw():
	if grabbed_node == null:
		draw_rect(Rect2(-32, -32, 64, 64), Color.red, false, 0.1)

func _on_Grid_mouse_grid_enter(grid):
	is_in_grid = true

func _on_Grid_mouse_grid_leave(grid):
	is_in_grid = false

func _on_cursor_move(world_position):
	if grabbed_node != null and grabbed_node is GridObject:
		if not is_in_grid:
			grabbed_node.position = world_position
			grabbed_node.check_valid_position(false)
		else:
			grabbed_node.snap_to_grid(world_position)
			grabbed_node.check_valid_position(true)
	else:
		self.position = world_position

func grab_node(node):
	if grabbed_node != null:
		grabbed_node.queue_free()
	
	grabbed_node = node
	grabbed_node.is_grabbed = true
	update()
	get_parent().add_child(grabbed_node)
