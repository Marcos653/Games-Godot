extends CharacterBody2D

signal laser(pos, direction)
signal grenade(pos, direction)

var can_laser: bool = true
var can_grenade: bool = true

@export var max_speed: int = 500
var speed: int = max_speed

func hit():
	Globals.health -= 10

func _process(_delta):
	
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	# Rotate
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - global_position).normalized()
	var angle_to_mouse = atan2(direction_to_mouse.y, direction_to_mouse.x)
	var angle_correction = deg_to_rad(90)  # Example: fix 90 degrees
	rotation = angle_to_mouse + angle_correction

	# laser shooting input
	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_just_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -=  1
		# randomly selected a marker 2D for the laser
		$GPUParticles2D.emitting = true
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$Timer.start()
		# emit the position we selected
		laser.emit(selected_laser.global_position, player_direction)

	# grenade shooting input
	if Input.is_action_just_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		# randomly selected a marker 2D for the laser
		var grenade_markers = $GrenadeStartPositions.get_children()
		var selected_grenade = grenade_markers[randi() % grenade_markers.size()]
		can_grenade = false
		$GrenadeReoladTimer.start()
		# emit the position we selected
		grenade.emit(selected_grenade.global_position, player_direction)

func _on_timer_timeout():
	can_laser = true

func _on_grenade_reolad_timer_timeout():
	can_grenade = true
