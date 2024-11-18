extends Node


func _process(delta):
	self.text = str(GameManager.player_health)
