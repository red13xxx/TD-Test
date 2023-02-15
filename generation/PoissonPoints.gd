extends Reference
class_name PoissonPoints

const noise_period = 128
const noise_texture_scale = 1.5 # Wie häufig soll die Periode Textur circa wiederholt werden über die gesamte breite

var radius
var size
var max_tries
var noise
var base_coll_radius
var noise_factor
var cell_size
var grid_size
var grid
var noise_position_scale

func _init(radius: float, size: Vector2, noise_factor: float, max_tries: int = 30):
	self.radius = radius
	self.size = size
	self.max_tries = max_tries
	self.noise_factor = noise_factor
	noise_position_scale = noise_period * noise_texture_scale / max(size.x, size.y)
	noise = _get_simplex_noise()
	base_coll_radius = radius * 2
	cell_size = base_coll_radius / sqrt(2)
	grid_size = Vector2(ceil(size.x / cell_size), ceil(size.y / cell_size))
	grid = [PoolIntArray()]
	grid.resize(grid_size.x * grid_size.y)
	grid.fill(-1)

func generate_points():
	var points = []
	var spawn_points = []
	var spawn_point = Vector2(rand_range(0, size.x), rand_range(0, size.y))
	spawn_points.append(spawn_point)
	points.append(spawn_point)
	
	grid[_coordw(spawn_point.x, spawn_point.y)] = points.size() - 1
	
	while spawn_points.size() > 0:
		spawn_points.shuffle()
		var point = spawn_points.pop_back()
		var found = false
		
		for i in max_tries:
			var rand_angle = rand_range(0, PI * 2)
			var noise_radius = _get_radius_at_point(point)
			var distance = rand_range(noise_radius, noise_radius * 2)
			var v = Vector2.UP.rotated(rand_angle) * distance
			var new_point = point + v
			
			if _is_valid(new_point, points):
				points.append(new_point)
				grid[_coordw(new_point.x, new_point.y)] = points.size() - 1
				spawn_points.append(new_point)
				found = true
		
		if found:
			spawn_points.append(point)
	return points

func _is_valid(new_point: Vector2, points: Array):
	if 0 <= new_point.x && new_point.x < size.x && 0 <= new_point.y && new_point.y < size.y:
		
		var radius_for_new_point = _get_radius_at_point(new_point)
		var cells = ceil(radius_for_new_point / cell_size)
		
		var lower_check_x = max(0, floor(new_point.x / cell_size) - cells)
		var upper_check_x = min(grid_size.x, floor(new_point.x / cell_size) + cells)
		var lower_check_y = max(0, floor(new_point.y / cell_size) - cells)
		var upper_check_y = min(grid_size.y, floor(new_point.y / cell_size) + cells)
		
		for x in range(lower_check_x, upper_check_x):
			for y in range(lower_check_y, upper_check_y):
				var pid = grid[_coord(x, y)]
				if pid != -1:
					var radius_for_point = _get_radius_at_point(points[pid])
					if (points[pid] - new_point).length() < max(radius_for_new_point, radius_for_point):
						return false
		return true
	return false

func _coord(x: int, y: int):
	return y * grid_size.x + x

func _coordw(x: float, y: float):
	var xg = floor(x / cell_size)
	var yg = floor(y / cell_size)
	return _coord(xg, yg)
	

static func _get_simplex_noise():
	var noise = OpenSimplexNoise.new()
	return noise

func _get_radius_at_point(pos: Vector2):
	return base_coll_radius * (1 + (noise.get_noise_2dv(pos * noise_position_scale) + 1) * noise_factor / 2)
