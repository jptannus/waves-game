# DraggableStack
# 	This scene will hold a stack of a given node that can be draggable. 
#	This node won't receive any drops, you can only drag things out of it.
class_name DraggableStack
extends Node2D


signal mouse_pressed(droppable_area: DroppableArea)
signal item_added(node: Node2D)
signal item_removed()
signal got_empty()


@export var item: PackedScene
@export var infinite: bool = true
@export var quantity: int = 0


func _ready() -> void:
	if item:
		var node: Node2D = item.instantiate()
		set_item(node)


func set_item(node: Node2D) -> void:
	if %DropableArea.drop(node):
		item_added.emit(node)


func set_quantity(amount: int) -> void:
	quantity = amount
	

func resolve_drop() -> void:
	if !infinite and !%DropableArea.is_holding():
		quantity -= 1
		item_removed.emit()
		if quantity <= 0:
			%DropableArea.disable()
			got_empty.emit()
			return


func _on_dropable_area_mouse_pressed(droppable_area: DroppableArea) -> void:
	mouse_pressed.emit(droppable_area)


func _on_dropable_area_content_dragged(node: Node2D) -> void:
	if infinite:
		var new_node: Node2D = node.duplicate()
		%DropableArea.drop(new_node)


func _on_dropable_area_drop_resolved() -> void:
	resolve_drop()
		
