class_name EnemyBase
extends Area2D

#### Variables Export
export var hitpoints := 50.0
export var bullet: PackedScene
export var bullet_speed := 400
export var is_aimer := false

#### Variables
var can_shoot := false
var player: Player
var bullet_rot_correction := 0.0
var speed := 0.0
var path: Path2D
var follow: PathFollow2D
var allow_shoot := true
var is_shooting := false
var shoot_lines := {"shoot_on": false, "shoot_off": false}


#### Variables Onready
onready var shoot_sound := $ShootSFX
onready var shoot_positions := $ShootPositions
onready var bullet_container: Node


#### Setters y Getters
func set_speed(value: float) -> void:
	speed = value

func set_path(value: Path2D) -> void:
	path = value

func set_allow_shoot(value: bool) -> void:
	allow_shoot = value

func set_is_aimer(value: bool) -> void:
	is_aimer = value

#### Metodos
func _ready() -> void:
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.loop = false
	bullet_container = get_top_level().get_node("BulletsContainer")
	if is_aimer:
		get_player()


func _process(delta) -> void:
	move(delta)
	
	if is_aimer and not player == null:
		aim_to_player()
		
	if can_shoot and allow_shoot:
		shoot()


func get_top_level() -> Node:
	var parent := get_parent()
	while not "GameLevel" in parent.name:
		parent = parent.get_parent()
	
	return parent


func get_player() -> void:
	for child in get_top_level().get_children():
		if child is Player:
			player = child
			break


func move(delta: float) -> void:
	follow.offset += speed * delta
	position = follow.global_position
	
	if follow.unit_offset >= 1.0:
		queue_free()
	
	if follow.unit_offset >= 0.15 and not is_shooting and not shoot_lines.shoot_on:
		is_shooting = true
		can_shoot = true
		shoot_lines.shoot_on = true
	
	if follow.unit_offset >= 0.85 and is_shooting and not shoot_lines.shoot_off:
		is_shooting = false
		can_shoot = false
		allow_shoot = false
		shoot_lines.shoot_off = true

func aim_to_player():
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	bullet_rot_correction = rad2deg(rot) - 90.0
	rotation = rot_look


func shoot() -> void:
	can_shoot = false
	$GunTimer.start()
	shoot_sound.play()
	for i in range(shoot_positions.get_child_count()):
		var new_bullet := bullet.instance()
		new_bullet.create(
				shoot_positions.get_child(i).global_position,
				bullet_speed,
				0.0,
				shoot_positions.get_child(i).get_bullet_type(),
				1.0,
				shoot_positions.get_child(i).get_bullet_angle() + bullet_rot_correction)
		bullet_container.add_child(new_bullet)


func _on_GunTimer_timeout() -> void:
	can_shoot = true


func _on_area_entered(area) -> void:
	take_damage(area.get_damage())


func take_damage(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()
