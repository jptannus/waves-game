extends Node


signal combo_updated()
signal combo_started()
signal combo_ended()
signal score_updated()


var _score: int = 0
var _combo_score: int = 0
var _combo_multiplier: float = 1
var _combo_active: bool = false


func reset_score() -> void:
	_score= 0
	_combo_score = 0
	_combo_multiplier = 1
	_combo_active = false


func add_score_to_combo(amount: int) -> void:
	_update_combo(func ():
		_combo_score += amount
	)


func add_multiplier_to_combo(amount: float) -> void:
	_update_combo(func ():
		_combo_multiplier += amount
	)
	

func _update_combo(update: Callable) -> void:
	if !_combo_active:
		_start_combo()
	update.call()
	combo_updated.emit()


func finish_combo() -> void:
	add_to_score(ceil(_combo_score * _combo_multiplier))
	_reset_combo()
	_combo_active = false
	combo_ended.emit()


func add_to_score(amount: int) -> void:
	_score += amount
	score_updated.emit()
	

func get_score() -> int:
	return _score


func get_combo_score() -> int:
	return _combo_score
	

func get_combo_multiplier() -> float:
	return _combo_multiplier


func _start_combo() -> void:
	_reset_combo()
	_combo_active = true
	combo_started.emit()
	
	
func _reset_combo() -> void:
	_combo_score = 0
	_combo_multiplier = 1
