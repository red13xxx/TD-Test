extends Camera2D

export(int) var push_border_size = 50
export(int) var move_speed = 800

var mouse_in_screen = true

signal cursor_move(world_position)

func _process(delta):
	if mouse_in_screen:
		var mouse_position = get_viewport().get_mouse_position()
		
		var move = Vector2.ZERO
		var screen_size = get_viewport_rect()
		if mouse_position.y < push_border_size: 
			move.y -= 1
		if screen_size.size.y - mouse_position.y < push_border_size: 
			move.y += 1
		if mouse_position.x < push_border_size: 
			move.x -= 1
		if screen_size.size.x - mouse_position.x < push_border_size: 
			move.x += 1
		
		if move.length() != 0:
			var new_position = position + move * delta * move_speed
			var world_size: Vector2 = get_parent().get_world_size()
			var moved = false
			
			if is_between(new_position.x, 0, world_size.x - screen_size.size.x):
				position.x = new_position.x
				moved = true
			
			if is_between(new_position.y, 0, world_size.y - screen_size.size.y):
				position.y = new_position.y
				moved = true
			
			emit_signal("cursor_move", get_world_position(mouse_position))

func _input(event):
	if event is InputEventMouseMotion:
		emit_signal("cursor_move", get_world_position(event.position))

func get_world_position(viewport_position: Vector2) -> Vector2:
	return self.position + viewport_position * self.zoom

func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			mouse_in_screen = false
		NOTIFICATION_WM_MOUSE_ENTER:
			mouse_in_screen = true

func is_between(v, minNumber, maxNumber):
	return minNumber <= v and v < maxNumber
