extends Node2D

@export var available_items: Array[Item]


func get_resource_by_name(item_name: String) -> Item:
	var match_name = func(item: Item) -> bool:
		return item.name == item_name

	var index = available_items.find_custom(match_name)
	if index <= -1:
		return null
	return available_items.get(index)
