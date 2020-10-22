tool
class_name Player, "res://assets/player/extras/player_editor_icon.png"
extends KinematicBody2D
#### Señales
signal destroy

#### Enumerables
enum States { INIT, IDLE, RESPAWNING, ALIVE, MOVING, SHOOTING, GOD, DEAD }

#### Variables Export
export var speed := 200.0
export var bullet: PackedScene
export var bullet_damage_base := 0.1
export var shooting_rate_base := 0.1
export(
	int,
	"Nivel base",
	"Nivel 1",
	"Nivel 2",
	"Nivel 3",
	"Nivel 4") var damage_level = 0 setget set_damage_level, get_damage_level
export(
	int,
	"Nivel base",
	"Nivel 1",
	"Nivel 2",
	"Nivel 3",
	"Nivel 4") var rate_level = 0 setget set_rate_level, get_rate_level
export var bullet_speed := -700
export var bullet_speed_alt := -700
export var hitpoints := 2
export(Color, RGBA) var color_trail: Color
export var is_in_god_mode := false


#### Variables
var state = States.INIT
var state_text := "INIT"
var can_shoot := false
var can_move := true setget set_can_move, get_can_move
var speed_multiplier := 0.8
var speed_using := 0.0
var speed_shooting: float
var speed_respawning := 0
var bullet_type := 1
var bullet_speed_using := 0
var bullet_damage_using := 0.0 setget ,get_bullet_damage_using
var movement_bonus := 0.0
var damage_penalty := 0.85
var rate_damage_factor := 0.08
var bullet_damage := 0.0
var shooting_rate := 0.0


#### Variables Onready
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

func get_bullet() -> PackedScene:
	return bullet

func get_bullet_type() -> int:
	return bullet_type

func get_bullet_damage_using() -> float:
	return bullet_damage_using

func set_damage_level(value: int) -> void:
	damage_level = value

func get_damage_level() -> int:
	return damage_level

func set_rate_level(value: int) -> void:
	rate_level = value

func get_rate_level() -> int:
	return rate_level

func set_can_move(value: bool) -> void:
	can_move = value

func get_can_move() -> bool:
	return can_move

#### Metodos
func _ready() -> void:
	add_to_group("player")
	change_state(States.IDLE)
	sprite.material.set_shader_param("outline_color", color_trail)
	#animation_play.play("init")
	speed_shooting = speed * speed_multiplier
	set_ship_atributes()

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		movement = speed_using * get_direction().normalized()
		movement_bonus = 0.0 if movement.y >= 0 else -100.0
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
# warning-ignore:standalone_ternary
		change_state(States.MOVING) if direction.length() > 0 else change_state(States.IDLE)
	
	return direction


func set_ship_atributes() -> void:
	shooting_rate = attribute_calculator("shooting_rate")
	bullet_damage = attribute_calculator("bullet_damage")
	gun_timer.wait_time = shooting_rate
	speed_using = speed
	bullet_damage_using = bullet_damage
	bullet_speed_using = bullet_speed

func attribute_calculator(attribute: String) -> float:
	if attribute == "shooting_rate":
		var sr = shooting_rate_base - (shooting_rate_base * rate_level * rate_damage_factor)
		return sr
	elif attribute == "bullet_damage":
		var bd = bullet_damage_base + (bullet_damage_base * damage_level * rate_damage_factor)
		return bd
	
	return 0.0

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
		bullet_damage_using = bullet_damage * 1.0 
	else:
		bullet_speed_using = bullet_speed_alt
		bullet_damage_using = bullet_damage * damage_penalty


func shoot() -> void:
	animation_effects.play("shoot")
	shoot_sound.play()
	for shoot_position in shoot_positions.get_children():
		shoot_position.shoot_bullet(
			bullet_speed_using + movement_bonus,
			0.0,
			bullet_type,
			bullet_damage_using
			)


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
		change_state(States.DEAD)
		emit_signal("destroy")
		animation_play.stop()
		animation_play.clear_queue()
		explosion.play("explosion")
		animation_play.play("destroy")

func disabled_collider() -> void:
	change_state(States.DEAD)
	

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
			can_shoot = false
			gun_timer.stop()
			is_in_god_mode = true
			state_text = "RESPAWNING"
		States.ALIVE:
			speed_using = speed
			can_shoot = true
			is_in_god_mode = false
			state_text = "ALIVE"
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
			$DamageCollider.set_deferred("disabled", true)
			state_text = "DEAD"
	state = new_state


#TODO: quitar esto
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		pause_mode = PAUSE_MODE_PROCESS
		get_tree().paused = !get_tree().paused
	
	if Input.is_action_just_pressed("ui_test_player_dead"):
		die()
