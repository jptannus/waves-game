class_name GivePointsAction
extends TileBehaviorAction

func do_action(_tile_map: Array[Array], tile: Tile, _pos: Vector2i) -> void:
	tile.emit_add_base_points_to_score()
	for item in tile.get_items():
		if item.award_points:
			tile.emit_add_score(item.points)
		if item.award_multiplier:
			tile.emit_add_multiplier(item.multiplier)
