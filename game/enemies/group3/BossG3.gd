extends EnemyBoss

#### Variables export
export var freq := 2.0
export var amplitude := 160.0
export var speed_decay := 0.08


#### Variables
var time := 0.0
var vertical_speed := 0.0
var original_amplitude := 0.0
var remaining_parts := 2
var bomb := preload("res://game/bullets/Bomb.tscn")


#### Variables onready
onready var left_part := $LeftPart
onready var right_part := $RightPart


#### Metodos
func _ready() -> void:
	add_shoot_positions_to_container(3, $ShootPositions3)
	vertical_speed = speed
	original_amplitude = amplitude
	is_aimer = false
#	toogle_area_shoot(true)
	right_part.toogle_shooting("bullet", true)
	right_part.toogle_shooting("bomb", true)
	left_part.toogle_shooting("bullet", true)
	left_part.toogle_shooting("bomb", true)
	spawn_shield(0.7)
	can_shoot = false


func _physics_process(delta: float) -> void:
	time += delta
	speed = cos(time * freq) * amplitude
	vertical_speed -= speed_decay
	if abs(vertical_speed) <= 2.0:
		go_backward()
		
	position += Vector2(speed, vertical_speed) * delta

func manage_shooting():
	shoot(current_shoot_positions_shooting)


func go_backward() -> void:
	amplitude *= 0.6
	original_speed *= -1
	vertical_speed = original_speed
	speed_decay *= -1

func _on_EnemyPart_destroyed() -> void:
	if is_alive:
		remaining_parts -= 1
		current_shoot_positions_shooting = shoot_positions_container[2]
		$GunTimer.wait_time *= 0.90
		bullet_speed *= 0.90
		if ((right_part == null and not left_part.get_is_alive())
			or (left_part == null and not right_part.get_is_alive())):
					get_node_or_null("EnemyShield").queue_free()
					switch_shootin_state(true)
					amplitude = original_amplitude
					current_shoot_positions_shooting = shoot_positions_container[3]
		
		if remaining_parts == 0:
			get_node_or_null("EnemyShield").queue_free()
			amplitude = original_amplitude * 1.2
			current_shoot_positions_shooting = shoot_positions_container[1]


func die() -> void:
	.die()
	set_process(false)
	set_physics_process(false)
	$BombTimer.stop()
	if left_part != null:
		left_part.die_from_boss()
	if right_part != null:
		right_part.die_from_boss()


func execute_low_life_behavior() -> void:
	switch_shootin_state(false)
	shoot_bomb()


func shoot_bomb() -> void:
	for pos in $BombPositions.get_children():
		var new_bomb := bomb.instance()
		new_bomb.global_position = pos.position
		add_child(new_bomb)
	
	$BombTimer.start()


func _on_Part_half_life() -> void:
	if is_alive:
		get_node_or_null("EnemyShield").queue_free()
		switch_shootin_state(true, 1.2)
		amplitude = original_amplitude
		
		if right_part != null and right_part.get_is_alive():
			right_part.toogle_shooting("bullet", false)
			right_part.toogle_shooting("bomb", false)
			right_part.spawn_shield(0.2)
		if left_part != null and left_part.get_is_alive():
			left_part.toogle_shooting("bullet", false)
			left_part.toogle_shooting("bomb", false)
			left_part.spawn_shield(0.2)
		
		$PartTimer.start()


func _on_PartTimer_timeout() -> void:
	if is_alive:
		spawn_shield(0.7)
		switch_shootin_state(false)
		if left_part != null:
			left_part.destroy_shield()
			left_part.toogle_shooting("bullet", true)
			left_part.toogle_shooting("bomb", true)
			
		if right_part != null:
			right_part.destroy_shield()
			right_part.toogle_shooting("bullet", true)
			right_part.toogle_shooting("bomb", true)


func _on_BombTimer_timeout() -> void:
	shoot_bomb()
