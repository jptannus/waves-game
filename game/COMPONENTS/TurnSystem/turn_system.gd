class_name TurnSystem
extends Node

signal round_started()
signal round_ended()
signal all_rounds_ended()
signal turn_started()
signal turn_ended()

@export var total_rounds: int = 10
@export var total_turns_per_round: int = 15
@export var turn_time_based: bool = true
@export var turn_time_interval: float = 10.0 # in seconds

var _is_paused: bool = false
var _turn_counter: int = 0
var _round_counter: int = 0

func start_round() -> void:
	if _is_paused:
		return
	if _round_counter < total_rounds:
		_round_counter += 1
		round_started.emit()
		start_turn()
	else:
		_round_counter = 0
		all_rounds_ended.emit()


func end_round() -> void:
	reset_turn_counter()
	round_ended.emit()
	start_round()


func get_round_counter() -> int:
	return _round_counter


func pause() -> void:
	if !_is_paused:
		%Timer.set_paused(true)
		_is_paused = true
	
	
func resume() -> void:
	if _is_paused:
		%Timer.set_paused(false)
		_is_paused = false
	
	
func is_time_based() -> bool:
	return turn_time_based && turn_time_interval > 0.0


func start_turn() -> void:
	# TODO: write something here to prevent a turn to be started while another is in progress
	if !_is_paused:
		if _turn_counter < total_turns_per_round:
			_turn_counter += 1
			turn_started.emit()
			if is_time_based():
				_start_timer()


func end_turn() -> void:
	if _turn_counter < total_turns_per_round:
		if is_time_based():
			turn_ended.emit()
			start_turn()
		else:
			turn_ended.emit()
	else:
		turn_ended.emit()
		end_round()


func reset_turn_counter() -> void:
	_turn_counter = 0


func get_turn_counter() -> int:
	return _turn_counter


func get_turn_time_left() -> float:
	return %Timer.time_left


func _start_timer() -> void:
	%Timer.start(turn_time_interval)


func _on_timer_timeout() -> void:
	end_turn()
