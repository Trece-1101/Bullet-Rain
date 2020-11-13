class_name Player, "res://assets/player/extras/player_editor_icon.png"
extends KinematicBody2D
#### Señales
signal destroy
signal use_ultimate
signal use_drone

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
var hitpoints := 3 setget ,get_hitpoints
export(Color, RGBA) var color_trail: Color
var is_in_god_mode := false setget set_is_in_god_mode
export var god := false


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
var rate_damage_factor := 0.09
var bullet_damage := 0.0
var shooting_rate := 0.0
var drone := preload("res://game/player/Drone.tscn")
var has_drones := false
var allow_drones := false setget set_allow_drones
var drone_can_shoot := false
var can_ultimatear := false  setget set_can_ultimatear
var is_alive := true setget ,get_is_alive


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

func set_is_in_god_mode(value: bool) -> void:
	is_in_god_mode = value

func get_hitpoints() -> int:
	return hitpoints

func set_allow_drones(value: bool) -> void:
	allow_drones = value

func set_can_ultimatear(value: bool) -> void:
	can_ultimatear = value

func get_is_alive() -> bool:
	return is_alive

#### Metodos
func _ready() -> void:
	add_to_group("player")
	is_alive = true
	global_position = Vector2(960.0, 920.0)
	change_state(States.IDLE)
	sprite.material.set_shader_param("outline_color", color_trail)
	speed_shooting = speed * speed_multiplier
	var stats:Dictionary = GlobalData.get_stats_by_name(self.name)
	damage_level = stats.dmg_level
	rate_level = stats.rate_level
	set_ship_atributes()

func _physics_process(_delta: float) -> void:
	movement = speed_using * get_direction().normalized()
	movement_bonus = 0.0 if movement.y >= 0 else -100.0
	
	move_and_slide(movement, Vector2.ZERO)

func _process(_delta: float) -> void:
	if has_drones and drone_can_shoot:
		shoot_drone()
	shoot_input()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_drone"):
		if not has_drones and allow_drones:
			has_drones = true
			drone_can_shoot = true
			allow_drones = false
			$UltDroneActivated.play()
			emit_signal("use_drone")
			$DroneGunTimer.start()
			for pos in $DronesPositions.get_children():
				var new_drone := drone.instance()
				new_drone.position = pos.position
				new_drone.connect("end_drone", self, "stop_drone_shooting")
				add_child(new_drone)
		else:
			$UltDroneDisabled.play()
	
	if event.is_action_pressed("ui_ultimate"):
		if can_ultimatear:
			$UltDroneActivated.play()
			emit_signal("use_ultimate")
			can_ultimatear = false
			get_node("Ultimate").use_ultimate()
		else:
			$UltDroneDisabled.play()


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
	$DroneGunTimer.wait_time = shooting_rate
	speed_using = speed
	bullet_damage_using = bullet_damage
	bullet_speed_using = bullet_speed
	var new_ultimate: Ultimate
	
	match self.name:
		"PlayerInterceptor":
			new_ultimate = UltimateInterceptor.new()
		"PlayerBomber":
			new_ultimate = UltimateBomber.new()
		"PlayerStealth":
			new_ultimate = UltimateStealth.new()
		_:
			print("ERROR")
	
	new_ultimate.name = "Ultimate"
	add_child(new_ultimate)

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

func shoot_drone() -> void:
	drone_can_shoot = false
	$ShootDroneSFX.play()
	$DronesPositions/DroneLeft/ShootPosition.shoot_bullet(
		bullet_speed_using + movement_bonus,
		0.0,
		bullet_type,
		bullet_damage_using
	)

	$DronesPositions/DroneRight/ShootPosition.shoot_bullet(
		bullet_speed_using + movement_bonus,
		0.0,
		bullet_type,
		bullet_damage_using
	)

func stop_drone_shooting() -> void:
	has_drones = false
	drone_can_shoot = false
	$DroneGunTimer.stop()

func _on_GunTimer_timeout() -> void:
	can_shoot = true

func _on_DroneGunTimer_timeout() -> void:
	drone_can_shoot = true

func take_damage() -> void:
	if not is_in_god_mode:
		hitpoints -= 1
		hitpoint_sound.play()
		if hitpoints == 0:
			die()
		else:
			GlobalData.substract_hitpoints(hitpoints)
			animation_play.queue("damage")

func die() -> void:
	if not is_in_god_mode:
		bypass_god_mode()

func bypass_god_mode() -> void:
	GlobalData.substract_hitpoints(0)
	is_alive = false
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
			if not god:
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
			if has_drones:
				drone_can_shoot = false
				$DroneGunTimer.stop()
				for child in get_children():
					if child is Drone:
						child.queue_free()
			state_text = "DEAD"
	state = new_state





