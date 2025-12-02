extends Node2D

@export var board_rows: int = 5
@export var board_columns: int = 5
@export var tile_inventory_list: ProbabilityList

@onready var game_ui: GameUI = $GameUI

@onready var _drag_n_drop_manager: DragNDropManager = DragNDropManager.new(self)

var _tile_placement_enabled: bool = true


func _ready() -> void:
	_setup_board()
	_setup_inventory()
	_setup_turn_system()
	_setup_score_system()
	game_ui.hide_bird()

#region Board Management
########################### Board Management ##################################

func _setup_board() -> void:
	%Board.create_empty_board(board_columns, board_rows)
	%Board.selector_pressed.connect(_on_board_selector_pressed)
	%Board.tile_removed.connect(_on_board_tile_removed)


func _on_board_selector_pressed(_pos: Vector2i) -> void:
	if _bird_action_active:
		%Board.hide_selectors()
		_end_bird_action(_pos)


func _on_board_tile_removed(tile: Tile, pos: Vector2i) -> void:
	tile.place_tile.connect(_on_tile_place_tile)
	for behavior in tile.get_behaviors():
		if behavior.should_it_trigger(TileBehaviorTrigger.TileLifeCycle.DESTROYED, tile):
			behavior.do_actions(%Board.get_tile_map(), tile, pos)


func _on_tile_place_tile(tile: Tile, pos: Vector2i) -> void:
	%Board.drop_tile_at(tile, pos)

###############################################################################
#endregion

#region Inventory + Drag n Drop
###################### Inventory + Drag n Drop ################################

func _setup_inventory() -> void:
	_refill_inventory()


func _on_board_mouse_pressed(droppable_area: DroppableArea, _pos: Vector2) -> void:
	if !_tile_placement_enabled:
		return

	if !droppable_area.is_holding():
		var tile: Tile = %TileInventory.take_first_tile()
		if tile:
			droppable_area.drop(tile)
	else:
		_drag_n_drop_manager.handle_droppable_area_pressed(droppable_area)


func _on_tile_inventory_mouse_pressed(droppable_area: DroppableArea) -> void:
	if !_tile_placement_enabled:
		return
	_drag_n_drop_manager.handle_droppable_area_pressed(droppable_area)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed == false:
			if !_tile_placement_enabled:
				return
			_drag_n_drop_manager.handle_mouse_button_released()


func _on_board_dropped(node: Node2D, pos: Vector2) -> void:
	if node is Tile:
		node.play_place_sound()
		for behavior in node.get_behaviors():
			if behavior and behavior.should_it_trigger(TileBehaviorTrigger.TileLifeCycle.PLACED, node):
				behavior.do_actions(%Board.get_tile_map(), node, pos)


func _on_tile_inventory_tile_taken(_tile: Tile) -> void:
	_pass_the_turn()


func _refill_inventory() -> void:
	if !tile_inventory_list:
		push_error("No tile inventory list was set")
		return

	var tile_resource: TileResource = tile_inventory_list.get_random_item().get_value()
	%TileInventory.add_tile_by_name(tile_resource.name)


func _disable_tile_placement() -> void:
	_tile_placement_enabled = false
	%TileInventory.visible = false
	%Board.disable_tile_click()


func _enable_tile_placement() -> void:
	_tile_placement_enabled = true
	%TileInventory.visible = true
	%Board.enable_tile_click()

##############################################################################
#endregion

#region Turn Management
########################## Turn Management ####################################

var _first_round: bool


func _setup_turn_system() -> void:
	_first_round = true
	%TurnSystem.total_turns_per_round = initial_bird_turn
	%TurnSystem.start_round() # Each round = Bird play
	%TurnSystem.turn_ended.connect(_on_turn_end)
	%TurnSystem.round_ended.connect(_on_round_end)
	%TurnSystem.round_started.connect(_on_round_started)
	%TurnSystem.round_started.connect(_update_round_ui)
	%TurnSystem.all_rounds_ended.connect(_on_last_round_end)
	_setup_turn_ui()


func _pass_the_turn() -> void:
	%TurnSystem.end_turn()


func _on_turn_end() -> void:
	if %TurnSystem.get_turn_counter() >= 1:
		if %Board.is_full() && %TurnSystem.get_turn_counter() < %TurnSystem.total_turns_per_round:
			%TurnSystem.end_round()
			_refill_inventory()
		else:
			_start_new_turn()


func _on_round_started() -> void:
	_start_bird_action()


func _start_new_turn() -> void:
	_refill_inventory()
	%TurnSystem.start_turn()


func _on_round_end() -> void:
	_first_round = false
	%TurnSystem.total_turns_per_round = bird_every_turns


func _on_last_round_end() -> void:
	SceneManager.change_scene(SceneManager.GAME_OVER)


func _update_round_ui() -> void:
	game_ui.turn_current_value.text = str(%TurnSystem.get_round_counter() - 1)


func _setup_turn_ui() -> void:
	game_ui.turn_total_value.text = "/" + str(%TurnSystem.total_rounds - 1)
	_update_round_ui()


func _is_last_bird() -> bool:
	return %TurnSystem.get_round_counter() == %TurnSystem.total_rounds

##############################################################################
#endregion

#region Bird Management
########################## Bird Management ####################################

@export var initial_bird_turn: int = 10
@export var bird_every_turns: int = 5
@export var bird_tile_delay: float = 0.3

var _bird_action_active: bool = false


func _is_bird_turn(turn: int) -> bool:
	if turn < initial_bird_turn:
		return false
	if turn == initial_bird_turn:
		return true
	if turn > initial_bird_turn:
		return turn % bird_every_turns == 0
	return false


func _start_bird_action() -> void:
	%Bird.play_ready_audio()
	game_ui.show_bird()
	_bird_action_active = true
	_disable_tile_placement()
	%Board.show_selectors()


func _end_bird_action(pos: Vector2i) -> void:
	game_ui.hide_bird()
	_show_combo_counter()
	if pos.x == -1:
		_call_bird_fly(pos, Vector2i(0, 1))
		await _bird_pass_on_column(pos.y, false)
	elif pos.y == -1:
		_call_bird_fly(pos, Vector2i(1, 0))
		await _bird_pass_on_row(pos.x, false)
	elif pos.x == board_rows:
		_call_bird_fly(pos, Vector2i(0, -1))
		await _bird_pass_on_column(pos.y, true)
	elif pos.y == board_columns:
		_call_bird_fly(pos, Vector2i(-1, 0))
		await _bird_pass_on_row(pos.x, true)

	if !_is_last_bird():
		_enable_tile_placement()

	ScoreSystem.finish_combo()
	_hide_combo_counter()
	_bird_action_active = false

	if _is_last_bird():
		%TurnSystem.end_round()


func _call_bird_fly(pos: Vector2i, direction: Vector2i) -> void:
	%Bird.fly(
		%Board.get_global_selector_position(pos),
		board_rows,
		%Board.tile_height,
		direction,
		bird_tile_delay,
	)


func _bird_pass_on_row(row: int, reversed: bool) -> void:
	for column in board_columns:
		await get_tree().create_timer(bird_tile_delay).timeout
		if !reversed:
			_bird_activate_tile_at(row, column)
		else:
			_bird_activate_tile_at(row, board_columns - 1 - column)


func _bird_pass_on_column(column: int, reversed: bool) -> void:
	for row in board_rows:
		await get_tree().create_timer(bird_tile_delay).timeout
		if !reversed:
			_bird_activate_tile_at(row, column)
		else:
			_bird_activate_tile_at(board_rows - 1 - row, column)


func _bird_activate_tile_at(row: int, column: int) -> void:
	var tile: Tile = %Board.get_tile_at(row + 1, column + 1)
	if !tile:
		return

	for behavior in tile.get_behaviors():
		if behavior.should_it_trigger(TileBehaviorTrigger.TileLifeCycle.ACTIVATED, tile):
			tile.add_score.connect(_on_tile_add_score)
			tile.add_multiplier.connect(_on_tile_add_multiplier)
			behavior.do_actions(%Board.get_tile_map(), tile, Vector2i(row, column))
	%Board.clear_tile(row + 1, column + 1)


func _on_tile_add_score(score: int) -> void:
	ScoreSystem.add_score_to_combo(score)


func _on_tile_add_multiplier(multiplier: float) -> void:
	ScoreSystem.add_multiplier_to_combo(multiplier)

##############################################################################
#endregion

#region Score Management
########################## Score Management ##################################

func _setup_score_system() -> void:
	ScoreSystem.reset_score()
	ScoreSystem.combo_updated.connect(_update_combo_ui)
	ScoreSystem.score_updated.connect(_on_score_updated)

	_update_score_ui()
	_hide_combo_counter()


func _on_score_updated() -> void:
	_update_score_ui()


func _show_combo_counter() -> void:
	game_ui.combo_points_value.text = "0"
	game_ui.combo_multiplier_value.text = "0"
	game_ui.combo_container.visible = true


func _hide_combo_counter() -> void:
	#game_ui.combo_container.visible = false #INFO: Hidden for now so I can see the score!
	pass


func _update_score_ui() -> void:
	game_ui.score_value.text = str(ScoreSystem.get_score())


func _update_combo_ui() -> void:
	game_ui.combo_points_value.text = str(ScoreSystem.get_combo_score())
	game_ui.combo_multiplier_value.text = str(ScoreSystem.get_combo_multiplier())

##############################################################################
#endregion
