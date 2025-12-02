class_name TileInventory
extends Node2D

@export var fixed_stacks: bool = true

const DRAGGABLE_STACK = preload("uid://clo1x1p02cdk2")

signal mouse_pressed(droppable_area: DroppableArea)
signal tile_taken(tile: Tile)

@export var max_size: int = 9999

var _inventory_size: int = 0
var _inventory: Dictionary[String, int] = { }
var _instances: Dictionary[String, DraggableStack] = { }


func add_tile(tile: Tile) -> bool:
	return add_tile_by_name(tile.get_tile_name())


func add_tile_by_name(tile_name: String) -> bool:
	if is_full():
		return false

	_add_tile_to_inventory(tile_name)
	_inventory_size += 1
	return true


func take_tile(tile_name: String) -> Tile:
	var tile = _silent_take_tile(tile_name)
	tile_taken.emit.call_deferred(tile)
	return tile


func _silent_take_tile(tile_name: String) -> Tile:
	if !_inventory.has(tile_name):
		return null

	_remove_tile_from_inventory(tile_name)
	var tile = TileDatabase.create_tile_by_name(tile_name)
	return tile


func take_first_tile() -> Tile:
	if _inventory.size() <= 0:
		return null
	return take_tile(_inventory.keys().get(0))


func take_first_stack() -> DraggableStack:
	if _instances.size() <= 0:
		return null
	return _instances.get(_instances.keys().get(0))


func is_full() -> bool:
	return _inventory_size >= max_size


func _add_tile_to_inventory(tile_name: String) -> void:
	var tile_amount = 1
	if _inventory.has(tile_name):
		tile_amount += _inventory.get(tile_name)
	else:
		_create_tile_instance(tile_name)
	_inventory.set(tile_name, tile_amount)


func _remove_tile_from_inventory(tile_name: String) -> void:
	if _inventory.has(tile_name):
		var tile_amount = _inventory.get(tile_name) - 1
		_inventory.set(tile_name, tile_amount)
		_inventory_size -= 1
		if tile_amount <= 0:
			_inventory.erase(tile_name)
			_remove_tile_instance(tile_name)


func _create_tile_instance(tile_name: String) -> void:
	if !_instances.has(tile_name):
		var tile = TileDatabase.create_tile_by_name(tile_name)
		if tile:
			var stack := _create_tile_stack(tile_name)
			stack.set_node(tile)
			stack.set_quantity(1)
			add_child(stack)
			_instances.set(tile_name, stack)
		else:
			push_error("Cannot add unkwon tile " + tile_name + " to the inventory")


func _remove_tile_instance(tile_name: String) -> void:
	if _instances.has(tile_name):
		var tile = _instances.get(tile_name)
		_instances.erase(tile_name)
		remove_child(tile)
		tile.queue_free()


func _create_tile_stack(tile_name: String) -> DraggableStack:
	var stack: DraggableStack = DRAGGABLE_STACK.instantiate()
	stack.mouse_pressed.connect(_on_mouse_pressed)
	stack.node_removed.connect(_on_node_removed(tile_name))
	stack.infinite = false
	return stack


func _on_mouse_pressed(droppbable_area: DroppableArea) -> void:
	mouse_pressed.emit(droppbable_area)


func _on_node_removed(tile_name: String) -> Callable:
	return func():
		tile_taken.emit(_silent_take_tile(tile_name))
