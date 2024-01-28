extends Area2D

var rotation_speed: int = 3
var available_options: Dictionary = {'laser': 50, 'grenade': 25, 'health': 25}
var type: String = weighted_choice(available_options)

var direction: Vector2
var distance: int = randi_range(150, 250)

func _ready():
	
	if type == 'laser':
		$Sprite2D.modulate = Color(0.1, 0.2, 0.8)
		
	if type == 'grenade':
		$Sprite2D.modulate = Color(0.8, 0.2, 0.1)

	if type == 'health':
		$Sprite2D.modulate = Color(0.1, 0.8, 0.1)
		
	# tween 
	var target_pos = position + direction * distance
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"position",target_pos,0.5)
	tween.tween_property(self, "scale",Vector2(1,1), 0.3).from(Vector2(0,0))

func _process(delta):
	rotation += rotation_speed * delta

func weighted_choice(weights_dict: Dictionary) -> String:
	var total_weight: int = 0
	# Calculate the total weight
	for weight in weights_dict.values():
		total_weight += weight
	var random_num: int = randi() % total_weight
	var weight_sum: int = 0

	for key in weights_dict.keys():
		weight_sum += weights_dict[key]

		if random_num < weight_sum:
			return key

	return "" # Fallback if something goes wrong

func _on_body_entered(_body):
	if type == 'laser':
		Globals.laser_amount += 5
		
	if type == 'grenade':
		Globals.grenade_amount += 1
	
	if type == 'health':
		Globals.health += 10

	$AudioStreamPlayer2D.play()
	$Sprite2D.hide()
	await $AudioStreamPlayer2D.finished
	queue_free()
