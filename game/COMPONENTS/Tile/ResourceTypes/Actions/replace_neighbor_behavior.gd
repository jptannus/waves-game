class_name ReplaceNeighborBehavior
extends TileBehaviorAction

@export var target_tile_name: String
@export var transform_to_tile_name: String


func do_action(tile_map: Array[Array], tile: Tile, pos: Vector2i) -> void:
	for_each_neighbor_run(transform_neighbor, tile_map, tile, pos)


func transform_neighbor(tile_map: Array[Array], _tile: Tile, pos: Vector2i) -> void:
	if is_tile_in_position_named(tile_map, pos, target_tile_name):
		var old_tile := get_tile_in_position(tile_map, pos)
		var new_tile: Tile = TileDatabase.create_tile_by_name(transform_to_tile_name)
		old_tile.transform_into_tile(new_tile)
