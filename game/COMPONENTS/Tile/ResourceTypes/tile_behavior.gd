class_name TileBehavior
extends Resource


@export var trigger: TileBehaviorTrigger
@export var actions: Array[TileBehaviorAction]
@export var description: String


func do_actions(tile_map: Array[Array], tile: Tile, pos: Vector2i) -> void:
	for action in actions:
		action.do_action(tile_map, tile, pos)
	

func get_description() -> String:
	return description


func should_it_trigger(cycle: TileBehaviorTrigger.TileLifeCycle, tile: Tile) -> bool:
	return trigger.can_trigger(cycle, tile)
	
