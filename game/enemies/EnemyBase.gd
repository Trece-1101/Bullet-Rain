class_name EnemyBase
extends Area2D
#### Señales
signal enemy_destroyed()

#### Variables Export
export var hitpoints := 50.0
export var is_aimer := false setget set_is_aimer
export var test_escene := false

#### Variables
var player: Player
var speed := 0.0 setget set_speed
var path: Path2D setget set_path
var follow: PathFollow2D
var allow_shoot := true setget set_allow_shoot, get_allow_shoot
var inside_play_screen := false setget set_inside_play_screen, get_inside_play_screen
var end_of_path := 1.0

#### Variables Onready
onready var hit_sfx := $HitSFX
onready var explosion_sfx := $ExplosionSFX
onready var damage_collider := $DamageCollider

#### Setters y Getters
func set_speed(value: float) -> void:
	speed = value

func set_path(value: Path2D) -> void:
	path = value

func set_allow_shoot(value: bool) -> void:
	allow_shoot = value

func get_allow_shoot() -> bool:
	return allow_shoot

func set_is_aimer(value: bool) -> void:
	is_aimer = value

func set_inside_play_screen(value: bool) -> void:
	inside_play_screen = value

func get_inside_play_screen() -> bool:
	return inside_play_screen

#### Metodos
func _ready() -> void:
	if path != null:
		follow = PathFollow2D.new()
		path.add_child(follow)
		follow.loop = false

	if is_aimer:
		get_player()


func _process(delta) -> void:
	if path != null:
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

	check_mid_of_path()
	check_end_of_path()


func check_end_of_path() -> void:
	if follow.unit_offset >= self.end_of_path:
		var action:String = path.at_end_of_path()
		if action == "free":
			queue_free()
		elif action == "stop":
			speed = 0.0

func check_mid_of_path() -> void:
	pass


func _on_area_entered(area) -> void:
	if area.is_in_group("Bullet"):
		take_damage(area.get_damage())


func take_damage(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		emit_signal("enemy_destroyed")
		$AnimationPlayer.play("destroy")
	else:
		hit_sfx.play()

func play_explosion_sfx() -> void:
	explosion_sfx.play()

func disabled_collider() -> void:
	allow_shoot = false
	damage_collider.set_deferred("disabled", true)
