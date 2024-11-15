extends Node

var enemy_count: int = 0

var enemies = {}
var enemy_positions = {}

func add_enemy(enemy):
	# Get the instance ID of the enemy node
	var enemy_id = enemy.get_instance_id()
	
	# Store the enemy node along with its ID
	enemies[enemy_id] = enemy
	# add its position
	enemy_positions[enemy_id] = enemy.global_position

func update_enemy_position(enemy):
	enemy_positions[enemy.get_instance_id()] = enemy.global_position

func no_enemy_at_pos(test_pos: Vector2) -> bool:
	for i in enemy_positions:
		if enemy_positions[i] == test_pos:
			return false
	return true
	
