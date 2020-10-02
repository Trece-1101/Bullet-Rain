class_name EnemyBandit
extends EnemyShooter

#### Variables
var aim_error := 0.0
var is_leader := false
var floackers := []

#### Metodos
func _ready() -> void:
	for child in get_children():
		if child is EnemyFlock:
			floackers.append(child)
	
	if is_aimer and not player == null:
		randomize()
		aim_error = rand_range(-10.0, 10.0)


func _on_AimTimer_timeout() -> void:
	if not player == null:
		check_aim_to_player()

func _process(_delta: float):
	if is_aimer and not player == null:
		check_aim_to_player()

func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look) + aim_error
	bullet_rot_correction = rad2deg(rot) - 90.0 + aim_error
	rotation_degrees = my_rotation

func die() -> void:
	.die()
	yield(get_tree().create_timer(0.8), "timeout")
	if floackers.size() > 0:
		for floacker in floackers:
			if floacker != null:
				floacker.play_explosion()
