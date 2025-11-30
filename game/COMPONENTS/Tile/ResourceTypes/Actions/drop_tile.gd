class_name DropTileAction
extends TileBehaviorAction


@export var drop_tile_name: String
@export var drop_probability: float


func do_action(_tile_map: Array[Array], tile: Tile, pos: Vector2i) -> void:
	if randf() > drop_probability:
		var new_tile = TileDatabase.create_tile_by_name(drop_tile_name)
		if new_tile:
			tile.emit_place_tile(new_tile, pos)
