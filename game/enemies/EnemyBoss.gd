class_name EnemyBoss
extends EnemyBase

#### Señales
signal destroy()

#### Enumerables
enum States {IDLE, HIGH_LIFE, HALF_LIFE, LOW_LIFE, DEAD }

#### Variables Export
export var bullet: PackedScene
export var bullet_speed := 400.0
export var test_shoot := false
export var start_position := Vector2.ZERO
export var minion_spawn_delay := 1.5
export(Array, Vector2) var minions_positions := []
export var minion: PackedScene
export(Array, NodePath) var indestructible_bullets
export var life_thresholds := {"half_life": 0.5, "low_life": 0.25}

#### Variables
var bullet_rot_correction := 0.0
var is_shooting := false
var original_speed := 0.0
var can_shoot := false setget set_can_shoot, get_can_shoot
var current_shoot_positions_shooting: Node2D
var life_status := {"half_life": false, "low_life": false}
var original_hitpoints: float
var is_aimer = true
var shield := preload("res://game/enemies/EnemyShield.tscn")
var state = States.HIGH_LIFE

#### Variables Onready
#onready var shoot_sound := $ShootSFX
onready var gun_timer := $GunTimer
onready var wait_timer := $WaitTimer
onready var shoot_sfx := $ShootSFX
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
	if indestructible_bullets.size() > 0:
		set_indestructible_bullet()
	
	global_position = start_position
	original_hitpoints = hitpoints
	current_shoot_positions_shooting = shoot_positions_container[1]
	can_shoot = true
	self.allow_shoot = true
	
	original_speed = self.speed
	get_player()


func _process(_delta: float) -> void:
	if hitpoints <= original_hitpoints * life_thresholds.half_life and not life_status.half_life:
		change_state(States.HALF_LIFE)
	elif hitpoints <= original_hitpoints * life_thresholds.low_life and not life_status.low_life:
		change_state(States.LOW_LIFE)
	
	if is_aimer and not player == null and is_alive:
		check_aim_to_player()
	
	if can_shoot and self.allow_shoot:
		manage_shooting()

func change_state(new_state) -> void:
	match new_state:
		States.IDLE:
			can_shoot = false
		States.HIGH_LIFE:
			execute_high_life_behavior()
		States.HALF_LIFE:
			life_status.half_life = true
			execute_half_life_behavior()
		States.LOW_LIFE:
			life_status.low_life = true
			execute_low_life_behavior()
		States.DEAD:
			is_aimer = false
			can_shoot = false
			gun_timer.stop()
			wait_timer.stop()
			is_alive = false
			animation_player.play("ultra_destroy")
	state = new_state


func set_indestructible_bullet() -> void:
	for path in indestructible_bullets:
		get_node(path).set_bullet_type(0)

func manage_shooting() -> void:
	pass

func execute_high_life_behavior() -> void:
	pass

func execute_half_life_behavior() -> void:
	pass

func execute_low_life_behavior() -> void:
	pass

func add_shoot_positions_to_container(key: int, shoot_positions: Node2D) -> void:
	shoot_positions_container[key] = shoot_positions


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


func switch_shootin_state(value: bool, wait := 0.0) -> void:
	if value:
		yield(get_tree().create_timer(wait),"timeout")
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


func spawn_shield(size := 1.0) -> void:
	var new_shield := shield.instance()
	new_shield.position = $ShieldPosition.position
	new_shield.scale = Vector2(size, size)
	new_shield.name = "EnemyShield"
	add_child(new_shield)


func disabled_collider() -> void:
	.disabled_collider()
	self.can_shoot = false


func _on_GunTimer_timeout() -> void:
	can_shoot = true


func _on_WaitTimer_timeout() -> void:
	can_shoot = true
	get_node_or_null("EnemyShield").queue_free()

func die() -> void:
	emit_signal("destroy")
	change_state(States.DEAD)
