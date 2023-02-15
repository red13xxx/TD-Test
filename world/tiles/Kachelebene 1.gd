extends TileMap

func _ready():
	for tid in self.tile_set.get_tiles_ids():
		var name = self.tile_set.tile_get_name(tid)
		var sc = self.tile_set.tile_get_shape_count(tid)
		print_debug(name, sc)
