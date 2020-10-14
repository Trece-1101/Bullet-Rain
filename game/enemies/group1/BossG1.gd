extends EnemyBoss

var shoot_counting := 0
var alternative_shoot_positions_shooting: Node2D

func manage_shooting():
	shoot(current_shoot_positions_shooting)

#	shoot_counting += 0
#	if shoot_counting > 1 and shoot_counting < 10:
#		for shoot_positions in current_shoot_positions_shooting.get_children():
#			shoot_positions.change_separation(1)
#	elif shoot_counting == 10:
#		can_shoot = false
#		gun_timer.stop()
#		wait_timer.start()
#		current_shoot_positions_shooting = shoot_positions_container[2]
#


func execute_half_life_behavior() -> void:
	print("half_life")


func execute_low_life_behavior() -> void:
	print("low_life")
