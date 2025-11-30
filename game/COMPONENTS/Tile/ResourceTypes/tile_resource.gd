class_name TileResource
extends Resource


@export_group("General")
@export var name: String
@export var art: CompressedTexture2D
@export var printable_string: String
@export var behaviors: Array[TileBehavior]
@export var tile_placement_rule: TilePlacementRule
@export var base_points: int = 0


@export_group("Item 1")
@export var item1: Item
@export var item1_position: Vector2i

@export_group("Item 2")
@export var item2: Item
@export var item2_position: Vector2i

@export_group("Item 3")
@export var item3: Item
@export var item3_position: Vector2i

@export_group("Item 4")
@export var item4: Item
@export var item4_position: Vector2i


func get_printable() -> String:
	return printable_string
