extends CharacterBody2D

@export var time_between_moves := 0.6

var move_timer := 0.0
var player = null

func _ready():
	move_timer = randf_range(0, time_between_moves)
	
	position = Utilities.snap_to_grid(position)
	
	EnemyManager.add_enemy(self)

	var players = get_tree().get_nodes_in_group("player")
	player = players[0]


func _physics_process(delta):
	if move_timer <= 0.0:
		find_valid_move()
		
	move_timer -= delta



func find_valid_move():
	move_timer = time_between_moves
	
	var direction_to_player = (player.global_position - global_position).normalized()
	var target_move_dir = Utilities.grid_dir(direction_to_player)
	
	if move_is_valid(target_move_dir):
		$GridMovement.move(target_move_dir)
		EnemyManager.update_enemy_position(self)
	elif move_is_valid(Utilities.rotate_clockwise(target_move_dir)):
		$GridMovement.move(Utilities.rotate_clockwise(target_move_dir))
		EnemyManager.update_enemy_position(self)
	elif move_is_valid(Utilities.rotate_counterclockwise(target_move_dir)):
		$GridMovement.move(Utilities.rotate_counterclockwise(target_move_dir))
		EnemyManager.update_enemy_position(self)



func move_is_valid(target_move_dir) -> bool:
	$RayCast2D.target_position = target_move_dir * Constants.TILE_SIZE
	$RayCast2D.force_raycast_update() # Update the `target_position` immediately
	
	var player_in_way = false
	if $RayCast2D.is_colliding() && $RayCast2D.get_collider().is_in_group("player"):
		player_in_way = true
	
	var target_pos = global_position + Vector2(target_move_dir.x, target_move_dir.y) * Constants.TILE_SIZE
	
	if EnemyManager.no_enemy_at_pos(target_pos) and !player_in_way:
		return true
	else:
		return false
