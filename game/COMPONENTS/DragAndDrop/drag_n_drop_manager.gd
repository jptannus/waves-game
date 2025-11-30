class_name DragNDropManager
extends Node
## DragNDropManager
## 	This class handles the drag and drop events and actions to ensure it works.
## 	This class should expose drag and drop events to be used to make game decisions
## 	The idea behind this class is that it doesn't know what it carries, it just needs
##	to be a Node2D.

const DRAGGABLE_SCENE = preload("uid://cd3ou25t1u4ei")

# Scene that is being dragged by the mouse
var _draggable: Draggable = null
# Scene that will be the parent of the tile being dragged by the mouse
var _draggable_parent: Node2D
# The area where the drag started
var _origin: DroppableArea


func _init(draggable_parent: Node2D) -> void:
	set_draggable_parent(draggable_parent)


func set_draggable_parent(draggable_parent: Node2D) -> void:
	_draggable_parent = draggable_parent


# Function that handles the input event of whem the mouse is pressed over
# a draggable area. Here the decision is made of what to be done.
func handle_droppable_area_pressed(droppable_area: DroppableArea) -> void:
	if !_draggable and !droppable_area.is_drop_only() and droppable_area.is_holding():
		var draggable: Draggable = DRAGGABLE_SCENE.instantiate()
		draggable.dropped.connect(_on_draggable_drop)
		_draggable = draggable
		_draggable_parent.add_child(draggable)
		_origin = droppable_area
		draggable.start_dragging(droppable_area.drag(), droppable_area)


func handle_mouse_button_released() -> void:
	if _draggable:
		_draggable.drop()
		_origin.resolve_drop()


# This is its own function so we can add more logic for when a tile is placed
func _on_draggable_drop() -> void:
	_remove_draggable()


func _remove_draggable() -> void:
	if _draggable:
		_draggable_parent.remove_child(_draggable)
		_draggable.queue_free()
		_draggable = null
