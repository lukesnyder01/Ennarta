extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):  # Check if the colliding body is the player
		queue_free()  # Destroy the berrywith function body.
