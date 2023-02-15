extends GridObject

var Bullet = preload("res://Scenes/Bullet.tscn")

var is_cooldown
export(int) var shooting_range = 200
export(int) var bullet_damage = 1
export(int) var bullet_speed = 800
export(float) var cooldown = 0.1
export(float) var turn_rate = PI
export(float) var spread = PI / 20

var nextBarrel = "right"

func _physics_process(delta):
	var closestEnemy: Node2D = get_closest_enemy()
	
	if closestEnemy != null and closestEnemy.position.distance_to(self.position) < shooting_range:
		var targetRotation = (closestEnemy.position - self.position).angle()
		var is_looking_at = turn_to(targetRotation, delta)
		if not is_cooldown and is_looking_at:
			shoot()
	

func get_closest_enemy():
	var tree := self.get_tree()
	var enemies := tree.get_nodes_in_group("enemies")
	var closestEnemy: Node2D = null
	var closestDistance := 99999
	for e in enemies:
		var d = e.position.distance_squared_to(self.position)
		if closestEnemy == null or d < closestDistance:
			closestEnemy = e
			closestDistance = d
	
	return closestEnemy

func turn_to(target_rotation, delta):
	var self_rotation = fposmod(self.rotation, PI * 2)
	
	var d_clockwise = fposmod(target_rotation - self_rotation, PI * 2)
	var d_anticlockwise = fposmod(self_rotation - target_rotation, PI * 2)
	
	var distance_to_turn = d_clockwise if d_clockwise < d_anticlockwise else -d_anticlockwise
	var max_turn = turn_rate * delta
	var frame_turn = clamp(distance_to_turn, -max_turn, max_turn)
	
	self.rotation = fposmod(self_rotation + frame_turn, PI * 2)
	
	return distance_to_turn ==  frame_turn

func shoot():
	
	var p;
	if nextBarrel == "left":
		p = $LeftBarrel.global_position
		nextBarrel = "right"
	elif nextBarrel == "right":
		p = $RightBarrel.global_position
		nextBarrel = "left"
	
	var rotation = self.rotation + rand_range(-spread, spread)
	
	var b = Bullet.instance().init(p, rotation, bullet_speed, bullet_damage)
	
	self.get_parent().add_child(b)
	
	$Cooldown.start(cooldown)
	is_cooldown = true


func _on_Cooldown_timeout():
	is_cooldown = false
