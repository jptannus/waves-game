class_name Tile
extends Node2D

## Emitted when something wants to transform this tile into another one
signal transform_into(tile: Tile, new_tile: Tile)
## Emitted when this tile is given any item
signal got_item(tile: Tile, item: Item)
## Emitted when this tile wants to increase the score
signal add_score(score: int)
## Emitted when this tile wants to increase the multiplier
signal add_multiplier(multiplier: float)
## Emitted when this tile was placed somewhere
signal place_tile(tile: Tile, pos: Vector2i)

const BASE_TILE = preload("uid://bsf884j8ex5b1")

var _resource: TileResource
var _items: Dictionary[Item, Node2D]


## Creates and returns an instance of a basic tile
static func create_tile() -> Tile:
	return BASE_TILE.instantiate()


func _ready() -> void:
	%ArtSprite.scale = Vector2(0.4, 0.4)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%ArtSprite, "scale", Vector2(1.0, 1.0), 0.5)


func set_resource(resource: TileResource) -> void:
	_resource = resource
	set_tile_art(resource.art)


func get_behaviors() -> Array[TileBehavior]:
	return _resource.behaviors


func set_tile_art(art: Resource) -> void:
	%ArtSprite.texture = art


func get_tile_name() -> String:
	return _resource.name


func transform_into_tile(tile: Tile) -> void:
	await get_tree().create_timer(0.1).timeout
	transform_into.emit(self, tile)


func give_item(new_item: Item) -> void:
	if !new_item:
		return

	var item_matched := false
	var pos: Vector2
	match (new_item):
		_resource.item1:
			pos = _resource.item1_position
			item_matched = true
		_resource.item2:
			pos = _resource.item2_position
			item_matched = true
		_resource.item3:
			pos = _resource.item3_position
			item_matched = true
		_resource.item4:
			pos = _resource.item4_position
			item_matched = true

	if item_matched:
		if !_items.get(new_item):
			var node = _get_item_scene(new_item, pos)
			_items.set(new_item, node)
			add_child(node)
			got_item.emit(self, new_item)


func emit_add_score(score: int) -> void:
	add_score.emit(score)


func emit_add_multiplier(multiplier: float) -> void:
	add_multiplier.emit(multiplier)


func emit_add_base_points_to_score() -> void:
	if _resource.base_points:
		add_score.emit(_resource.base_points)


func get_items() -> Array[Item]:
	var owned_items: Array[Item] = []
	for item: Item in _items:
		owned_items.push_back(item)
	return owned_items


func emit_place_tile(tile: Tile, pos: Vector2i) -> void:
	place_tile.emit(tile, pos)


func play_place_sound() -> void:
	%AudioEffect.play()


func _get_item_scene(item: Item, pos: Vector2) -> Node2D:
	var node: Node2D = item.scene.instantiate()
	node.position = pos
	return node
