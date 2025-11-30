class_name TileBehaviorAction
extends Resource


func do_action(_tile_map: Array[Array], _tile: Tile, _pos: Vector2i) -> void:
	print("No action was set for this tile behavior action")


func for_each_neighbor_run(f: Callable, _tile_map: Array[Array], tile: Tile, pos: Vector2i) -> void:
	if pos.x < _tile_map.size():
		f.call(_tile_map, tile, Vector2i(pos.x + 1, pos.y))
	if pos.x > 1:
		f.call(_tile_map, tile, Vector2i(pos.x - 1, pos.y))
	if pos.y < _tile_map[0].size():
		f.call(_tile_map, tile, Vector2i(pos.x, pos.y + 1))
	if pos.y > 1:
		f.call(_tile_map, tile, Vector2i(pos.x, pos.y - 1))


func is_tile_in_position_named(_tile_map: Array[Array], pos: Vector2i, name: String) -> bool:
	var tile: Tile = _tile_map[pos.x - 1][pos.y - 1]
	return tile and tile.get_tile_name() == name


func get_tile_in_position(_tile_map: Array[Array], pos: Vector2i) -> Tile:
	return _tile_map[pos.x - 1][pos.y - 1]
