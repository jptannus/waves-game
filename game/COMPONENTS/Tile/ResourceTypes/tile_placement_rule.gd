class_name TilePlacementRule
extends Resource


@export var position_anywhere: bool = false
@export var filter_by_valid: bool = true
@export var valid_positions: Array[Vector2]
@export var invalid_positions: Array[Vector2]


func can_be_placed(_tile_map: Array[Array], position: Vector2) -> bool:
	if position_anywhere:
		return true
	if filter_by_valid:
		return valid_positions.find(position) > -1
	return invalid_positions.find(position) > -1
