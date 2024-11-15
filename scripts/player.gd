extends CharacterBody2D
 

@export var player_move_delay := 0.3
var move_timer := 0.0

var moving_direction: Vector2 = Vector2.ZERO

var recent_move := Vector2.ZERO

@export var tilemap: TileMap



func _ready():
	position = Utilities.snap_to_grid(position)
 

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_RIGHT:
			recent_move = Vector2.RIGHT
		elif event.keycode == KEY_LEFT:
			recent_move = Vector2.LEFT
		elif event.keycode == KEY_UP:
			recent_move = Vector2.UP
		elif event.keycode == KEY_DOWN:
			recent_move = Vector2.DOWN
		
		if move_timer <= 0.0:
			move_player(recent_move)
			recent_move = Vector2.ZERO


func _physics_process(delta):
	var input_direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		input_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_up"):
		input_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		input_direction = Vector2.DOWN
	
	if move_timer <= 0.0:
		
		if recent_move != Vector2.ZERO:
			move_player(recent_move)
			recent_move = Vector2.ZERO
			
		elif input_direction != Vector2.ZERO:
			move_player(input_direction)

	move_timer -= delta


func move_player(direction: Vector2i):
	
	move_timer = player_move_delay
	
	if moving_direction.length() == 0 && direction.length() > 0:
		var movement = Utilities.grid_dir(direction)
		
		$RayCast2D.target_position = movement * Constants.TILE_SIZE
		$RayCast2D.force_raycast_update() # Update the `target_position` immediately
		
		# Allow movement only if no collision in next tile
		if !$RayCast2D.is_colliding():
			var player_tile_coord = get_player_tile_coord()
			tilemap.randomize_player_sight_circle(player_tile_coord + direction)
			
			moving_direction = movement
			$AudioStreamPlayer2D.play()
			
			global_position = global_position + (moving_direction * Constants.TILE_SIZE)
			moving_direction = Vector2.ZERO

	

func get_player_tile_coord():
	var tile_coord = tilemap.local_to_map(global_position)
	return tile_coord

