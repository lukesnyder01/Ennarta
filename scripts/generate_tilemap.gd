extends TileMap

var sight_radius := 32
var circle_points = []  # Array to hold the circle points



var tile_atlas_coords = {
	"stone01": Vector2i(1, 0),
	"stone02": Vector2i(2, 0), 
	"tree01": Vector2i(3, 0),
	"rock01": Vector2i(4, 0),
	"water_deep": Vector2i(5, 0),
	"water_shallow": Vector2i(6, 0),
	
	"mud_puddles": Vector2i(6, 1),
	
	"dirt01": Vector2i(0, 1),
	"gravel02": Vector2i(1, 1),
	"plants01": Vector2i(2, 1),
	"bushes01": Vector2i(3, 1), 
	"gravel01": Vector2i(4, 1), 
	
	"flowers_pink": Vector2i(1, 2), 
	"flowers_gold": Vector2i(2, 3), 
	
	"footprint":Vector2i(1, 14),
}

var adjacency_rules = {
	"stone01": [],
	"stone02": [],
	"tree01": [],
	"dirt01": [],
	"gravel01": [],
	"gravel02": [],
	"plants01": [],
	"bushes01": [],
	"footprint": [],
}


func _ready():
	update_adjacency_rules()
	
	var world_size = sight_radius * 2
	var rect = Rect2(Vector2(-world_size/2, -world_size/2), Vector2(world_size, world_size)) # Rectangle area to randomize
	initialize_world(rect)
	
	generate_midpoint_circle(sight_radius)
	randomize_player_sight_circle(Vector2i.ZERO)



func generate_midpoint_circle(radius: int) -> Array:
	var x = radius
	var y = 0
	var p = 1 - radius
	
	# Add the initial points on each octant
	add_circle_points(circle_points, x, y)
	
	while x > y:
		y += 1
		if p <= 0:
			p = p + 2 * y + 1
		else:
			x -= 1
			p = p + 2 * y - 2 * x + 1
		
		if x < y:
			break
		
		# Add points for the current octant
		add_circle_points(circle_points, x, y)
		
		# Add points for the 45-degree mirrored octant
		if x != y:
			add_circle_points(circle_points, y, x)
	
	return circle_points


func add_circle_points(circle_points: Array, x: int, y: int):
	circle_points.append(Vector2i(x, y))
	circle_points.append(Vector2i(-x, y))
	circle_points.append(Vector2i(x, -y))
	circle_points.append(Vector2i(-x, -y))
	circle_points.append(Vector2i(y, x))
	circle_points.append(Vector2i(-y, x))
	circle_points.append(Vector2i(y, -x))
	circle_points.append(Vector2i(-y, -x))


func update_adjacency_rules():
	# Clear existing adjacency rules
	# adjacency_rules.clear()
	for i in tile_atlas_coords:
		adjacency_rules[i] = []

	var used_cells = get_used_cells(0)

	for tile_pos in used_cells:
		# Get the current tile's position
		#var tile_pos = Vector2(x, y)
		
		
		if get_cell_source_id(0, tile_pos) != -1:
			# Get the tile type and its coordinates in the atlas
			var tile_coords = get_cell_atlas_coords(0, tile_pos)
			var tile_type = tile_atlas_coords.find_key(tile_coords)
			
			# If the tile type is not found in the atlas, skip it
			if not tile_coords:
				continue
			
			# Add the current tile type to the adjacency rules if it's not already present
			if not adjacency_rules.has(tile_type):
				adjacency_rules[tile_type] = []
			
			# Get the neighbor's tile types, then add them to the adjacency rules
			var adjacent_tiles = get_adjacent_tile_types(tile_pos)

			
			if adjacent_tiles.is_empty() == false:
				for tile in adjacent_tiles:
					adjacency_rules[tile_type].append(tile)


func initialize_world(rect: Rect2):
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			if get_cell_source_id(0, Vector2i(x, y)) == -1:
				generate_tile_with_constraints(Vector2i(x, y))


func randomize_player_sight_circle(player_coords: Vector2i):
	for coord in circle_points:
		coord = coord + player_coords
		if get_cell_source_id(0, coord) == -1: # if the tile is empty
			generate_tile_with_constraints(coord)
			
			
	#		if randf() < 0.5:		
	#			var random_tile_key = tile_atlas_coords.keys().pick_random()
	#			set_cell(0, coord, 0, tile_atlas_coords[random_tile_key]) # Set the random tile at the specified coordinate
	#		else:
	#			set_cell(0, coord, 0, tile_atlas_coords["dirt01"])  # Set to gravel



func change_tile(tile_coord: Vector2i, tile_type: String):
	if get_cell_source_id(0, tile_coord) == -1:
		set_cell(0, tile_coord, 0, tile_atlas_coords[tile_type])


func generate_tile_with_constraints(position: Vector2i):
	var neighbors = get_adjacent_tile_types(position)
	var possible_tiles = get_possible_tiles(neighbors)
	if possible_tiles.size() != 0:
		var selected_tile = possible_tiles[randi() % possible_tiles.size()]
		change_tile(position, selected_tile)
	else:
		change_tile(position, "dirt01")

# Function to get the types of adjacent tiles
func get_adjacent_tile_types(position: Vector2i) -> Array:
	var adjacent_positions = [
		Vector2i(position.x, position.y - 1),  # Up
		Vector2i(position.x + 1, position.y),  # Right
		Vector2i(position.x, position.y + 1),  # Down
		Vector2i(position.x - 1, position.y),  # Left
	]
	
	var adjacent_tile_types = []

	for pos in adjacent_positions:
		var coords = get_cell_atlas_coords(0, pos)
		var tile_type = tile_atlas_coords.find_key(coords)
		if tile_type != null:
			adjacent_tile_types.append(tile_type)

	return adjacent_tile_types



func get_possible_tiles(neighbors: Array) -> Array:
	if neighbors.size() == 0:
		return tile_atlas_coords.keys()

	var possible_tiles = []
	for tile in tile_atlas_coords.keys(): # look at each tile type in the tile atlas dict
		if tile in adjacency_rules: # make sure adjacency rules are defined for the tile
			var valid_tile = true 
			for neighbor in neighbors:
				if neighbor not in adjacency_rules[tile]:
					valid_tile = false
					break
				else:
					for neighbors_possible_tiles in adjacency_rules[neighbor]:
						if neighbors_possible_tiles == tile:
							possible_tiles.append(tile)
		else:
			# If there are no adjacency rules defined for the tile, include it as a possible tile
			possible_tiles.append(tile)
	return possible_tiles
		