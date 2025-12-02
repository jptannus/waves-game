class_name DraggableStack
extends Node2D
## DraggableStack
## 	This scene will hold a stack of a given node that can be draggable.
##	This node won't receive any drops, you can only drag things out of it.

## When the mouse press the left_button on the area
signal mouse_pressed(droppable_area: DroppableArea)
## When a node is added to the stack
signal node_added(node: Node2D)
## When a node is removed from the stack
signal node_removed()
## When the stack gets empty
signal got_empty()

## The scene of what should be stacked
@export var node_scene: PackedScene
## Set infinity so the stack never get empty
@export var infinite: bool = true
## Set quantity of nodes in the stack (only relevant if infinity is false)
@export var quantity: int = 0


func _ready() -> void:
	if node_scene:
		var node: Node2D = node_scene.instantiate()
		set_node(node)


## Set the node that should be stacked
func set_node(node: Node2D) -> void:
	if %DroppableArea.drop(node):
		node_added.emit(node)


## Set the quantity of nodes in the stack
func set_quantity(amount: int) -> void:
	quantity = amount


## Handles the DroppableArea resolve drop event. Updating the state of the
## stack when an drag n drop action is resolved.
func resolve_drop() -> void:
	if !infinite and !%DroppableArea.is_holding():
		quantity -= 1
		node_removed.emit()
		if quantity <= 0:
			%DroppableArea.set_disabled(true)
			got_empty.emit()
			return


func _on_dropable_area_mouse_pressed(droppable_area: DroppableArea) -> void:
	mouse_pressed.emit(droppable_area)


func _on_dropable_area_content_dragged(node: Node2D) -> void:
	if infinite:
		var new_node: Node2D = node.duplicate()
		%DroppableArea.drop(new_node)
