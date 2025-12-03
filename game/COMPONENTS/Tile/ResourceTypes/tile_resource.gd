class_name TileResource
extends Resource

@export_group("General")
## Name of the tile (that is also used as an id for its type)
@export var name: String
## The texture to be added to a Sprite2D that will represent the tile in game
@export var art: CompressedTexture2D
## A string to be used for debug printing in the console
@export var printable_string: String
## A list of TileBehaviors this tile has
@export var behaviors: Array[TileBehavior]
## The rule to be used to validate if a tile can be placed
@export var tile_placement_rule: TilePlacementRule
## The amount of points this tile gives regardless of items
@export var base_points: int = 0
# Items that a tile can carry
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
