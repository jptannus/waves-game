class_name ProbabilityList
extends Resource
## ProbabilityList
## It is a list of items that have a value and a probability attached to it.
## It can provide a random item from the list respecting the probability of
##   the items, as long as they sum 1.0

@export var list: Array[ProbabilityListItem]


func get_random_item() -> ProbabilityListItem:
	if list.size() > 0:
		var rand = randf() # 0.0 ~ 1.0
		var sum = 0.0
		for item in list:
			if rand < item.probability + sum:
				return item
			sum += item.probability
	return null
