class_name TileSlot
extends Node2D

signal mouse_pressed(droppable_area: DroppableArea, pos: Vector2)
signal dropped(node: Node2D, pos: Vector2)
signal tile_removed(tile: Tile, pos: Vector2i)

var _row: int
var _column: int
var _tile: Tile
var _draggable: bool = true
var _disable_click: bool = false


func set_board_position(row: int, column: int) -> void:
	_row = row
	_column = column
	_update_position_text()


func set_tile(tile: Tile) -> void:
	_tile = tile
	%DroppableArea.drop(tile)


func replace_tile(tile: Tile) -> void:
	if _tile == tile:
		return
	%DroppableArea.delete_content()
	set_tile(tile)


func get_tile() -> Tile:
	return _tile


func set_draggable(value: bool) -> void:
	_draggable = value
	%DroppableArea.silent_drag()
	%DroppableArea.set_drop_only(!_draggable)


func remove_tile() -> void:
	var tile = _tile
	_tile = null
	%DroppableArea.delete_content()
	tile_removed.emit(tile, Vector2i(_row, _column))


func disable_click() -> void:
	_disable_click = true
	%DroppableArea.set_clickable(false)
	_highlight_off()
	
	
func enable_click() -> void:
	_disable_click = false
	%DroppableArea.set_clickable(true)


func _update_position_text() -> void:
	%PositionLabel.text = str(_row) + "," + str(_column)


func _on_dropable_area_mouse_pressed(droppable_area: DroppableArea) -> void:
	mouse_pressed.emit(droppable_area, Vector2(_row, _column))


func _on_dropable_area_dropped(node: Node2D) -> void:
	if node is Tile:
		_tile = node
		_tile.transform_into.connect(_on_transform_tile)
		dropped.emit(node, Vector2(_row, _column))
		_highlight_off()


func _on_transform_tile(_old_tile: Tile, new_tile: Tile) -> void:
	replace_tile(new_tile)


func _on_droppable_area_dragging_over(_node: Node2D) -> void:
	_highlight_on()


func _on_droppable_area_dragging_out(_node: Node2D) -> void:
	_highlight_off()


func _highlight_on() -> void:
	%Sprite2D.visible = false
	

func _highlight_off() -> void:
	%Sprite2D.visible = true


func _on_droppable_area_mouse_entered() -> void:
	if !_disable_click:
		_highlight_on()


func _on_droppable_area_mouse_exited() -> void:
	if !_disable_click:
		_highlight_off()
