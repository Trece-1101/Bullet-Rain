extends EnemyBoss

export(float, 0.5, 1.5) var free_speed := 2.0

var shoot_counting := 0
var can_make_move := true

onready var tween := $Tween

func _ready() -> void:
	make_your_move(choose_new_position())


func manage_shooting():
	shoot(current_shoot_positions_shooting)

func execute_half_life_behavior() -> void:
	tween.stop(self)
	make_your_move(start_position + Vector2(0.0, 100.0), 0.5)
	can_make_move = false
	switch_shootin_state(false)
	wait_timer.start()
	spawn_minions()
	spawn_shield()


func execute_low_life_behavior() -> void:
	#make_your_move(start_position + Vector2(0.0, 100.0), 0.5)
	free_speed *= 0.6
	current_shoot_positions_shooting = shoot_positions_container[2]
# warning-ignore:narrowing_conversion
	bullet_speed *= 1.4
	gun_timer.wait_time = gun_timer.wait_time * 0.85


func choose_new_position() -> Vector2:
	randomize()
	var new_position_x := rand_range(700.0, 1220.0)
	var new_position_y := rand_range(140.0, 280.0)
	return Vector2(new_position_x, new_position_y)


func make_your_move(new_position: Vector2, speed := free_speed) -> void:
	tween.interpolate_property(
		self,
		"global_position",
		global_position,
		new_position,
		speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	if can_make_move:
		yield(get_tree().create_timer(0.5), "timeout")
		make_your_move(choose_new_position())


func _on_WaitTimer_timeout() -> void:
	._on_WaitTimer_timeout()
	can_make_move = true
	make_your_move(choose_new_position())
