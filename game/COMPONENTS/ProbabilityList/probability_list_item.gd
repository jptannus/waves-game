class_name ProbabilityListItem
extends Resource
## ProbabilityListItem
## Item of a probability list. Contains a value and a probability to be selected

@export var value: Variant
@export var probability: float


func get_value() -> Variant:
	return value
