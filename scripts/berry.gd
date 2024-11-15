extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):  # Check if the colliding body is the player
		var player_audio_player = body.get_node("BerrySound")
		if player_audio_player:
			player_audio_player.play()  # Play the eating sound

		queue_free()  # Destroy the berrywith function body.
