extends EnemyBoss


var shoot_counting := 0
var player_detected := false
var oscilation := 0.0

onready var detector_cool_down := $DetectorCoolDown

func _ready() -> void:
	is_aimer = false

func _physics_process(delta: float) -> void:
	if not player_detected:
		player_detected = true
		detector_cool_down.start()
		speed = original_speed
		if global_position.x >= get_player_x():
			speed = -original_speed
		else:
			speed = original_speed
	
	if oscilation != 0:
		if position.y < 180.0 or position.y > 380.0:
			oscilation *= -1
	
	position.x += speed * delta
	position.y += oscilation * delta


func manage_shooting():
	shoot(current_shoot_positions_shooting)


func execute_half_life_behavior() -> void:
	switch_shootin_state(false)
	wait_timer.start()
	spawn_minions()
	spawn_shield()

func get_player_x() -> float:
	if player != null:
		return player.global_position.x
	else:
		return 960.0

func execute_low_life_behavior() -> void:
	current_shoot_positions_shooting = shoot_positions_container[2]
# warning-ignore:narrowing_conversion
	bullet_speed *= 1.2
	gun_timer.wait_time = gun_timer.wait_time * 0.85
	original_speed *= 1.15
	oscilation = 25.0



func _on_DetectorCoolDown_timeout() -> void:
	player_detected = false
