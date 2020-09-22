class_name EnemyBase
extends Area2D

#### Variables Export
export var hitpoints := 50.0

export var is_aimer := false

#### Variables
var player: Player
var speed := 0.0
var path: Path2D
var follow: PathFollow2D
var allow_shoot := true


#### Variables Onready
onready var shoot_sound := $ShootSFX
onready var shoot_positions := $ShootPositions
onready var gun_timer := $GunTimer


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

	if is_aimer:
		get_player()


func _process(delta) -> void:
	move(delta)



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
	
	check_shooting_status()
	check_end_of_path()


func check_end_of_path():
	pass


func check_shooting_status():
	pass


func _on_GunTimer_timeout() -> void:
	pass


func _on_area_entered(area) -> void:
	take_damage(area.get_damage())


func take_damage(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()
