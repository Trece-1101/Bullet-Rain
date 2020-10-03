tool
class_name Player
extends KinematicBody2D

#### Enumerables
enum States { INIT, IDLE, RESPAWNING, MOVING, SHOOTING, GOD, DEAD }

#### Variables Export
export var speed := 200.0
export var bullet: PackedScene
export var bullet_damage := 1.0
export var bullet_speed := -700
export var bullet_speed_alt := -700
export(float, 0.08, 0.32) var shooting_rate := 0.2
export var hitpoints := 4
export(Color, RGBA) var color_trail: Color
export var is_in_god_mode := false


#### Variables
var state = States.INIT
var state_text := "INIT"
var can_shoot := true
var speed_multiplier := 0.8
var speed_using := 0.0
var speed_shooting: float
var speed_respawning := 0
var bullet_type := 1
var bullet_speed_using := 0
var movement_bonus := 0.0


#### Variables Onready
onready var bullet_container: Node
onready var shoot_positions := $ShootPositions
onready var gun_timer := $GunTimer
onready var movement := Vector2.ZERO
onready var shoot_sound := $ShootSFX
onready var hitpoint_sound := $HitpointSFX
onready var explosion_sound := $ExplosionSFX
onready var bullet_change_sound := $BulletChangeSFX
onready var animation_play := $AnimationPlayer
onready var animation_effects := $AnimationEffects
onready var sprite := $Sprite
onready var explosion := $Explosion.get_node("ExplosionPlayer")

#### Setters y Getters
func set_movement(value: Vector2) -> void:
	movement = value

func get_movement() -> float:
	return movement.length()

func get_shoot_rate() -> float:
	return gun_timer.wait_time

func get_state() -> String:
	return state_text

func set_move_to_start(value: bool) -> void:
	if value:
		self.position = Vector2(960.0, 920.0)

#### Metodos
func _ready() -> void:
	add_to_group("player")
	change_state(States.IDLE)
	sprite.material.set_shader_param("outline_color", color_trail)
	animation_play.play("init")
	speed_shooting = speed * speed_multiplier
	gun_timer.wait_time = shooting_rate
	speed_using = speed
	bullet_speed_using = bullet_speed
	bullet_container = get_tree().get_nodes_in_group("bullets_container")[0]


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		movement = speed_using * get_direction().normalized()
		if movement.y >= 0:
			movement_bonus = 0
		else:
			movement_bonus = -100.0
	# warning-ignore:return_value_discarded

		move_and_slide(movement, Vector2.ZERO)


func _process(_delta: float) -> void:
	shoot_input()


func get_direction() -> Vector2:
	var direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if (direction.x == 0 and sprite.get_frame() != 1):
		sprite.set_frame(1)
	else:
		if (direction.x > 0 and sprite.get_frame() != 2):
			sprite.set_frame(2)
		elif (direction.x < 0 and sprite.get_frame() != 0):
			sprite.set_frame(0)
	
	if not state in [States.SHOOTING, States.DEAD, States.RESPAWNING]:
		if direction.length() > 0:
			change_state(States.MOVING)
		else:
			change_state(States.IDLE)
	
	return direction


func shoot_input() -> void:
	if Input.is_action_just_pressed("ui_change_bullet"):
		change_bullet()
	
	if Input.is_action_pressed("ui_shoot"):
		if can_shoot:
			change_state(States.SHOOTING)
			shoot()
			gun_timer.start()
			can_shoot = false
	
	if Input.is_action_just_released("ui_shoot"):
		change_state(States.IDLE)

func change_bullet() -> void:
	bullet_change_sound.play()
	bullet_type *= -1
	if bullet_type == 1:
		bullet_speed_using = bullet_speed
	else:
		bullet_speed_using = bullet_speed_alt

func shoot() -> void:
	animation_effects.play("shoot")
	shoot_sound.play()
	for i in range(shoot_positions.get_child_count()):
		var new_bullet := bullet.instance()
		new_bullet.create(
				self,
				shoot_positions.get_child(i).global_position,
				bullet_speed_using + movement_bonus,
				0.0,
				bullet_type,
				bullet_damage)
		bullet_container.add_child(new_bullet)


func _on_GunTimer_timeout() -> void:
	can_shoot = true

func take_damage() -> void:
	if not is_in_god_mode:
		hitpoints -= 1
		hitpoint_sound.play()
		if hitpoints == 0:
			die()
		else:
			animation_play.queue("damage")

func die() -> void:
	if not is_in_god_mode:
		animation_play.stop()
		animation_play.clear_queue()
		explosion.play("explosion")
		animation_play.play("destroy")

func disabled_collider() -> void:
	change_state(States.DEAD)
	$DamageCollider.set_deferred("disabled", true)

func play_explosion_sfx() -> void:
	explosion_sound.play()


func change_state(new_state) -> void:
	match new_state:
		States.IDLE:
			speed_using = speed
			state_text = "IDLE"
		States.MOVING:
			speed_using = speed
			state_text = "MOVING"
		States.RESPAWNING:
			speed_using = speed_respawning
			state_text = "RESPAWNING"
		States.SHOOTING:
			speed_using = speed_shooting
			state_text = "SHOOTING"
		States.GOD:
			is_in_god_mode = true
			state_text = "GOD"
		States.DEAD:
			speed_using = speed_respawning
			can_shoot = false
			gun_timer.stop()
			state_text = "DEAD"
	state = new_state
