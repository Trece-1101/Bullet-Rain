class_name EnemyBandit
extends EnemyShooter

#### Variables onready
onready var aim_tween := $AimTween
onready var aim_timer := $AimTimer


#### Metodos
func _ready() -> void:
	if is_aimer and not player == null:
		aim_timer.start()


func _on_AimTimer_timeout() -> void:
	if not player == null:
		check_aim_to_player()


func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rot_look
	bullet_rot_correction = rad2deg(rot) - 90.0
	aim_to_player(my_rotation)


func aim_to_player(my_rotation: float) -> void:
	aim_tween.interpolate_property(
		self, "rotation",
		rotation, my_rotation, aim_timer.wait_time,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	aim_tween.start()



func _on_AimTween_tween_completed(_object: Object, _key: NodePath) -> void:
	aim_timer.start()
