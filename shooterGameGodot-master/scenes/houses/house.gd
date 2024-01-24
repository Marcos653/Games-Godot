extends Area2D

signal player_entered
signal player_exited

func _on_body_entered(body):
	player_entered.emit(body)

func _on_body_exited(body):
	player_exited.emit(body)
