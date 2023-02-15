extends Path2D

var enemy = preload("res://enemy/Enemy.tscn")

var timer = 0
export var spawn_time = 5

func _physics_process(delta):
	timer += delta
	
	if timer > spawn_time:
		var new_enemy = enemy.instance()
		new_enemy.add_to_group("enemies")
		self.add_child(new_enemy)
		timer = 0

