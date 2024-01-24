extends Node

signal stat_change

var laser_amount = 20:
	set(value):
		laser_amount = value
		stat_change.emit()

var grenade_amount = 5:
	set(value):
		grenade_amount = value
		stat_change.emit()

var player_vulnerable: bool = true
var health = 60:
	set(value):
		if value > health:
			health = min(value, 100)
		else:
			if player_vulnerable:
				health = value
				player_vulnerable = false
				player_invulnerable_timer()
		stat_change.emit()

var player_pos: Vector2

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true
