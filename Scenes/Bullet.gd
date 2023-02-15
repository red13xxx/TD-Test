extends Area2D
class_name Bullet

var direction
var speed
var damage

onready var grid: Grid = get_parent()

func init(position: Vector2, rotation: float, speed: float, damage: int):
	self.direction = Vector2(1, 0).rotated(rotation)
	self.speed = speed
	self.global_position = position
	self.damage = damage
	return self

func _ready():
	self.rotate(self.direction.angle())

func _physics_process(delta):
	self.position += direction * speed * delta
	
	if not grid.is_world_pos_within_bounds(self.position):
		self.queue_free()
