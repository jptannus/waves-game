class_name ProbabilityListItem
extends Resource
## ProbabilityListItem
## Item of a probability list. Contains a value and a probability to be selected

## This is the value this item holds. It can be anything.
@export var value: Variant
## This is the probability of this item being selected.
@export_range(0.0, 1.0) var probability


## Returns the value of this item
func get_value() -> Variant:
	return value
