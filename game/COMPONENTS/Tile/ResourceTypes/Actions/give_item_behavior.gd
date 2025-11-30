class_name GiveItemBehavior
extends TileBehaviorAction


@export var target_tile_name: String
@export var item_name: String


func do_action(tile_map: Array[Array], tile: Tile, pos: Vector2i) -> void:
	for_each_neighbor_run(give_item, tile_map, tile, pos)


func give_item(tile_map: Array[Array], _tile: Tile, pos: Vector2i) -> void:
	if is_tile_in_position_named(tile_map, pos, target_tile_name):
		var tile := get_tile_in_position(tile_map, pos)
		tile.give_item(ItemDatabase.get_resource_by_name(item_name))
