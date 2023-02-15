extends PathFollow2D
class_name Enemy

export var speed = 100;
export var hitpoints = 20

signal end_of_path
signal enemy_death

func _physics_process(delta):
	self.offset += speed * delta
		
	if self.unit_offset >= 1:
		emit_signal("end_of_path")
		self.queue_free()

func _on_bullet_hit(area):
	var bullet = area
	if bullet is Bullet:
		self.hitpoints -= bullet.damage
		bullet.queue_free()
		
		if self.hitpoints <= 0:
			emit_signal("enemy_death")
			self.queue_free()
	
	
