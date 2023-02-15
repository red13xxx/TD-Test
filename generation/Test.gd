extends Node2D
tool

var points
export var radius: int = 10 setget _set_radius
export var draw_radius: int = 10 setget _set_draw_radius
export var size: Vector2 = Vector2(100, 100) setget _set_size
export var noise_factor: float = 2 setget _set_noise_factor

func _ready():
	generate_new_points()

func generate_new_points():
	var p = PoissonPoints.new(radius, size, noise_factor)
	points = p.generate_points()
	
	var img = p.noise.get_image(p.noise_period * p.noise_texture_scale, p.noise_period * p.noise_texture_scale)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	$Sprite.texture = tex
	$Sprite.scale = Vector2.ONE / p.noise_position_scale
	
	update()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color.blue, false, 1)
	for p in points:
		draw_circle(p, draw_radius, Color.red)

func _set_radius(value):
	radius = value
	generate_new_points()

func _set_draw_radius(value):
	draw_radius = value
	update()

func _set_size(value):
	size = value
	generate_new_points()

func _set_noise_factor(value):
	noise_factor = value
	generate_new_points()
