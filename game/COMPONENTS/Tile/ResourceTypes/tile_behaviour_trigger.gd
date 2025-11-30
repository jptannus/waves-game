class_name TileBehaviorTrigger
extends Resource

enum TileLifeCycle {
	DRAWN,
	PLACED, # Similar to spawned if not played. We could have both too.
	TURN_START,
	DURING_TURN,
	TURN_END,
	ACTIVATED, # By a bird or another tile
	DESTROYED,
}

@export var life_cycle: Array[TileLifeCycle]


func check_life_cycle(on_cycle: TileLifeCycle) -> bool:
	return life_cycle.find(on_cycle) > -1


func can_trigger(on_cycle: TileLifeCycle, _tile: Tile) -> bool:
	if !check_life_cycle(on_cycle):
		return false
	return true
