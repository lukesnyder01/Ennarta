extends Node2D
 
@export var self_node: Node2D

var moving_direction: Vector2 = Vector2.ZERO
 
func move(direction: Vector2) -> void:
	if direction.length() > 0:
		# make sure the move direction is only one of the cardinal directions
		moving_direction = Utilities.grid_dir(direction)
		# Calculate the new position based on the provided direction
		var new_position = self_node.global_position + (moving_direction * Constants.TILE_SIZE)
		# move immediately
		self_node.global_position = new_position
		moving_direction = Vector2.ZERO
