class_name EnemyBoss
extends EnemyBase


#### Variables Export
export var bullet: PackedScene
export var bullet_speed := 400
export var test_shoot := false
export var start_position := Vector2.ZERO
export var minion_spawn_delay := 1.5
export(Array, Vector2) var minions_positions := []
export var minion: PackedScene

#### Variables
var bullet_rot_correction := 0.0
var is_shooting := false
var is_boss := true setget ,get_is_boss
var original_speed := 0.0
var can_shoot := false setget set_can_shoot, get_can_shoot
var current_shoot_positions_shooting: Node2D
var life_status := {"half_life": false, "low_life": false}
var original_hitpoints: float
var is_aimer = true
var shield := preload("res://game/enemies/EnemyShield.tscn").instance()

#### Variables Onready
#onready var shoot_sound := $ShootSFX
onready var gun_timer := $GunTimer
onready var wait_timer := $WaitTimer
onready var shoot_positions_container := {
	1: $ShootPositions1,
	2: $ShootPositions2
	}


#### Setters y Getters
func set_can_shoot(value: bool) -> void:
	can_shoot = value

func get_can_shoot() -> bool:
	return can_shoot

func get_is_boss() -> bool:
	return is_boss

func get_bullet() -> PackedScene:
		return bullet


#### Metodos
func _ready() -> void:
	global_position = start_position
	original_hitpoints = hitpoints
	current_shoot_positions_shooting = shoot_positions_container[1]
	#ToDo: borrar esto en el build definitivo
	if test_shoot:
		can_shoot = true
		self.allow_shoot = true
	
	original_speed = self.speed
	get_player()


func _process(_delta: float) -> void:
	manage_process()
	if hitpoints <= original_hitpoints * 0.5 and not life_status.half_life:
		life_status.half_life = true
		execute_half_life_behavior()
	elif hitpoints <= original_hitpoints * 0.25 and not life_status.low_life:
		life_status.low_life = true
		execute_low_life_behavior()
	
	if is_aimer and not player == null:
		check_aim_to_player()
	
	if can_shoot and self.allow_shoot:
		manage_shooting()


func manage_shooting() -> void:
	pass

func manage_process() -> void:
	pass

func execute_half_life_behavior() -> void:
	pass

func execute_low_life_behavior() -> void:
	pass

func add_shoot_positions_to_container(key: String, shoot_positions: ShootPosition) -> void:
	shoot_positions_container[key] = shoot_positions


func shoot(shoot_positions: Node2D) -> void:
	if not can_shoot:
		return

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


func switch_shootin_state(value: bool) -> void:
	if value:
		can_shoot = true
	else:
		can_shoot = false
		gun_timer.stop()


func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look)
	bullet_rot_correction = rad2deg(rot) - 90.0
	rotation_degrees = my_rotation

func spawn_minions() -> void:
	for pos in minions_positions:
		yield(get_tree().create_timer(minion_spawn_delay),"timeout")
		var new_minion:EnemyBandit = minion.instance()
		new_minion.position = pos
		new_minion.set_can_shoot(true)
		new_minion.set_allow_shoot(true)
		new_minion.set_is_aimer(true)
		new_minion.set_inside_play_screen(true)
		get_parent().add_child(new_minion)

func spawn_shield() -> void:
	shield.position = $ShieldPosition.position
	add_child(shield)

func disabled_collider() -> void:
	.disabled_collider()
	self.can_shoot = false


func _on_GunTimer_timeout() -> void:
	can_shoot = true


func _on_WaitTimer_timeout() -> void:
	can_shoot = true
	shield.queue_free()


func die() -> void:
	queue_free()
