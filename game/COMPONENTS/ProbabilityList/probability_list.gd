class_name ProbabilityList
extends Resource

@export var list: Array[ProbabilityItem]


func get_random_item() -> ProbabilityItem:
	if list.size() > 0:
		var rand = randf() # 0.0 ~ 1.0
		var sum = 0.0
		for item in list:
			if rand < item.probability + sum:
				return item
			sum += item.probability
	return null
