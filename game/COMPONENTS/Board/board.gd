class_name Board
extends Node2D

signal dropped(node: Node2D, pos: Vector2)
signal mouse_pressed(droppable_area: DroppableArea, pos: Vector2)
signal selector_pressed(pos: Vector2i)
signal tile_removed(tile: Tile, pos: Vector2i)

@export var time_slot_scene: PackedScene
@export var board_selector_scene: PackedScene
@export var tile_width: float
@export var tile_height: float
@export var tile_spacing: float
@export var enable_moving_tiles: bool = false

var _tile_slots: Array[Array]
var _selectors: Array[BoardSelector]


func create_empty_board(width: int, height: int) -> void:
	var tile_map: Array[Array] = []
	for r in height:
		tile_map.push_back([])
		for c in width:
			tile_map[r].push_back(null)
	display_board(tile_map)


func display_board(tile_map: Array[Array]) -> void:
	_populate_tile_slots(tile_map)
	_create_board_selectors()
	hide_selectors()


func get_tile_slots() -> Array[Array]:
	return _tile_slots


func get_tile_map() -> Array[Array]:
	var tile_map: Array[Array] = []
	for row in _tile_slots.size():
		tile_map.push_back([])
		for tile_slot: TileSlot in _tile_slots[row]:
			tile_map[row].push_back(tile_slot.get_tile())
	return tile_map


func get_tile_at(row: int, column: int) -> Tile:
	var tile_slot: TileSlot = _tile_slots[row - 1][column - 1]
	return tile_slot.get_tile()


func clear_tile(row: int, column: int) -> void:
	var tile_slot: TileSlot = _tile_slots[row - 1][column - 1]
	tile_slot.remove_tile()


func show_selectors() -> void:
	for selector in _selectors:
		selector.visible = true
		selector.arrow.scale = Vector2(0.4, 0.4)
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(selector.arrow, "scale", Vector2(1.0, 1.0), 1.5)


func hide_selectors() -> void:
	for selector in _selectors:
		selector.visible = false


func drop_tile_at(tile: Tile, pos: Vector2i) -> void:
	var tile_slot: TileSlot = _tile_slots[pos.x - 1][pos.y - 1]
	tile_slot.replace_tile(tile)


func get_global_selector_position(pos: Vector2i) -> Vector2:
	var x = pos.y * tile_width + tile_width / 2
	var y = pos.x * tile_height + tile_height / 2
	return global_position + Vector2(x, y)


func is_full() -> bool:
	var result = true
	for row in _tile_slots:
		for tile_slot: TileSlot in row:
			if !tile_slot.get_tile():
				result = false
				break
		if !result:
			break
	return result


func _populate_tile_slots(tile_map: Array[Array]) -> void:
	if !time_slot_scene:
		push_error("Tile slot scene not defined")
		return

	_tile_slots = []
	for row in tile_map.size():
		_tile_slots.push_back([])
		for column in tile_map[row].size():
			var tile_slot := _create_tile_slot(row, column)
			_tile_slots[row].push_back(tile_slot)
			add_child(tile_slot)


func _create_tile_slot(row: int, column: int) -> TileSlot:
	var tile_slot: TileSlot = time_slot_scene.instantiate()
	tile_slot.set_draggable(enable_moving_tiles)
	tile_slot.dropped.connect(_on_tile_dropped)
	tile_slot.mouse_pressed.connect(_on_tile_mouse_pressed)
	tile_slot.tile_removed.connect(_on_tile_removed)
	tile_slot.set_board_position(row + 1, column + 1)
	tile_slot.position.x = column * (tile_width + tile_spacing)
	tile_slot.position.y = row * (tile_height + tile_spacing)
	return tile_slot


func _on_tile_dropped(node: Node2D, pos: Vector2) -> void:
	dropped.emit(node, pos)


func _on_tile_removed(tile: Tile, pos: Vector2i) -> void:
	tile_removed.emit(tile, pos)


func _on_tile_mouse_pressed(dropable_area: DroppableArea, pos: Vector2) -> void:
	mouse_pressed.emit(dropable_area, pos)


func _create_board_selectors() -> void:
	if !board_selector_scene:
		push_error("Board selector scene not defined")
		return

	_selectors = []
	for row in _tile_slots.size():
		var posy = row * (tile_height + tile_spacing) + 74
		# Left side of all rows
		_create_and_add_board_selector(Vector2(-64, posy), Vector2i(row, -1), -90)
		var posx = _tile_slots.size() * (tile_width + tile_spacing) + 32
		# Right side of all rows
		_create_and_add_board_selector(Vector2(posx, posy), Vector2i(row, _tile_slots.size()), 90)

	for column in _tile_slots[0].size():
		var posx = column * (tile_width + tile_spacing) + 64
		# Top side of all columns
		_create_and_add_board_selector(Vector2(posx, -44), Vector2i(-1, column), 0)
		var posy = _tile_slots.size() * (tile_width + tile_spacing) + 32
		# Down side of all columns
		_create_and_add_board_selector(Vector2(posx, posy), Vector2i(_tile_slots.size(), column), 180)


func _create_and_add_board_selector(pos: Vector2, initial_pos: Vector2i, angle: float) -> BoardSelector:
	var selector: BoardSelector = board_selector_scene.instantiate()
	selector.set_starting_position(initial_pos)
	selector.rotation_degrees = angle
	selector.position = pos + Vector2(32, 32)
	selector.scale = Vector2(0.5, 0.5)
	selector.pressed.connect(_on_selector_pressed)
	add_child(selector)
	_selectors.push_back(selector)
	return selector


func _on_selector_pressed(pos: Vector2i) -> void:
	selector_pressed.emit(pos)
