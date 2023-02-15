extends Node2D
class_name GameMap

onready var tiles = $"Kachelebene 1"

func has_tile_collision(cell_pos: Vector2):
	var tid = tiles.get_cellv(cell_pos)
	print_debug(cell_pos)
	print_debug(tiles.tile_set.tile_get_shape_count(tid))
	return tid == TileMap.INVALID_CELL || tiles.tile_set.tile_get_shape_count(tid) > 0
