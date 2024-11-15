extends Node


func grid_dir(dir) -> Vector2i:
	if abs(dir.x) > abs(dir.y):
		dir.y = 0
	else:
		dir.x = 0
	
	return dir.snapped(Vector2.ONE)

func snap_to_grid(pos) -> Vector2i:
	var grid_position = pos.snapped(Vector2.ONE * Constants.TILE_SIZE)
	grid_position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	return grid_position

func rotate_clockwise(v: Vector2i) -> Vector2i:
	return Vector2i(v.y, -v.x)
	
func rotate_counterclockwise(v: Vector2i) -> Vector2i:
	return Vector2i(-v.y, v.x)
