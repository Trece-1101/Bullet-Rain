class_name EnemyBossBT
extends EnemyBase

#### Señales
signal destroy()

#### Variables export
export var bullet: PackedScene
export var bullet_speed := 400.0
export var test_shoot := false
export(Array, NodePath) var indestructible_bullets
export var start_position := Vector2.ZERO
export var shoot_rate := 1.0
export var is_aimer = true

#### Variables
var original_hitpoints: float
var bullet_rot_correction := 0.0
var is_shooting := false
var original_speed := 0.0
var can_shoot := false setget set_can_shoot, get_can_shoot
var current_shoot_positions_shooting: Node2D
var shield := preload("res://game/enemies/EnemyShield.tscn")

#### Variables Onready
onready var gun_timer := $GunTimer
onready var wait_timer := $WaitTimer
onready var shoot_sfx := $ShootSFX
onready var tween := $Tween
onready var shoot_positions_container := {
	1: $ShootPositions1,
	2: $ShootPositions2
	}


#### Setters y Getters
func set_can_shoot(value: bool) -> void:
	can_shoot = value

func get_can_shoot() -> bool:
	return can_shoot

func get_bullet() -> PackedScene:
		return bullet

#### Metodos
func _ready() -> void:
	original_hitpoints = hitpoints
	original_speed = self.speed
	global_position = start_position
	can_shoot = true
	self.allow_shoot = true
	gun_timer.wait_time = shoot_rate
	get_player()
	current_shoot_positions_shooting = shoot_positions_container[1]
	if indestructible_bullets.size() > 0:
		set_indestructible_bullet()

func _process(delta: float) -> void:
	if is_aimer and not player == null and is_alive:
		check_aim_to_player()
	
	if can_shoot and self.allow_shoot:
		shoot(current_shoot_positions_shooting)

func shoot(shoot_positions: Node2D) -> void:
	if not can_shoot:
		return
	
	shoot_sfx.play()
	can_shoot = false
	gun_timer.start()
	for shoot_position in shoot_positions.get_children():
		shoot_position.shoot_bullet(
			bullet_speed,
			0.0,
			shoot_position.get_bullet_type(),
			1.0,
			bullet_rot_correction
		)

func set_indestructible_bullet() -> void:
	for path in indestructible_bullets:
		get_node(path).set_bullet_type(0)

func add_shoot_positions_to_container(key: int, shoot_positions: Node2D) -> void:
	shoot_positions_container[key] = shoot_positions

func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look)
	bullet_rot_correction = rad2deg(rot) - 90.0
	rotation_degrees = my_rotation

func check_aim_to_center() -> float:
	var dir = Vector2(960.0, 920.0) - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look)
	bullet_rot_correction = rad2deg(rot) - 90.0
	rotation_degrees = my_rotation
	return my_rotation

func look_at_center() -> void:
	tween.interpolate_property(
		self,
		"rotation_degrees",
		rotation_degrees,
		0,
		2.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()


func die() -> void:
	is_aimer = false
	can_shoot = false
	gun_timer.stop()
	wait_timer.stop()
	is_alive = false
	animation_player.play("ultra_destroy")

func _on_GunTimer_timeout() -> void:
	can_shoot = true

func _on_WaitTimer_timeout() -> void:
	pass # Replace with function body.

#### Tareas
func task_say_my_life(task) -> void:
	print("{hp} - {life}".format({"hp": hitpoints, "life": task.get_param(0)}))
	task.succeed()

func task_check_life(task) -> void:
	if hitpoints < original_hitpoints * task.get_param(0):
		task.succeed()
	else:
		task.failed()

func task_toggle_aim(task) -> void:
	if task.get_param(0) == "true":
		is_aimer = true
	else:
		is_aimer = false
		look_at_center()
	
	task.succeed()




