extends Node

@export var available_tiles: TileCollection

func get_resource_by_name(tile_name: String) -> TileResource:
	var match_name = func (resource: TileResource) -> bool:
		return resource.name == tile_name
	
	var index = available_tiles.tiles.find_custom(match_name)
	if index <= -1:
		return null
	return available_tiles.tiles.get(index) 


func create_tile_by_name(tile_name: String) -> Tile:
	var resource = get_resource_by_name(tile_name)
	if !resource:
		return null

	var tile := Tile.create_tile()
	tile.set_resource(get_resource_by_name(tile_name))
	return tile
