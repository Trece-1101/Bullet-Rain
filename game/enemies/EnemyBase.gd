class_name EnemyBase
extends Area2D
#### Señales
signal enemy_destroyed()

#### Variables Export
export var hitpoints := 50.0
export var is_aimer := false setget set_is_aimer


#### Variables
var can_take_damage := true
var player: Player
var speed := 0.0 setget set_speed
var path: Path2D setget set_path
var follow: PathFollow2D
var allow_shoot := true setget set_allow_shoot, get_allow_shoot
var inside_play_screen := false setget set_inside_play_screen, get_inside_play_screen
var end_of_path := 1.0 setget set_end_of_path, get_end_of_path
var is_stopper := false setget set_is_stopper
var explosions_sfx := [
	"res://assets/sounds/sfx/enemies/explosion/04enemyexplosion.wav",
	"res://assets/sounds/sfx/enemies/explosion/05enemyexplosion.wav",
	"res://assets/sounds/sfx/enemies/explosion/07enemyexplosion.wav"
	]


#### Variables Onready
onready var hit_sfx := $HitSFX
onready var explosion_sfx := $ExplosionSFX
onready var damage_collider := $DamageCollider
onready var motor := $Motor
onready var animation_player := $AnimationPlayer
onready var animation_player_2 := $AnimationPlayer2
onready var explosion_vfx := $Explosion2.get_node("ExplosionPlayer")
onready var sprite := $Sprite

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

func set_end_of_path(value: float) -> void:
	end_of_path = value

func get_end_of_path() -> float:
	return end_of_path

func set_is_stopper(value: bool) -> void:
	is_stopper = value


#### Metodos
func _ready() -> void:
	if path != null:
		follow = PathFollow2D.new()
		path.add_child(follow)
		follow.loop = false

	if is_aimer:
		get_player()
	
	get_random_explosion_sfx()


func _process(delta: float) -> void:
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
	if (!motor.emitting):
		motor.emitting = true
	follow.offset += speed * delta
	position = follow.global_position

	if is_stopper:
		 check_mid_of_path()
	check_end_of_path()


func check_end_of_path() -> void:
	if follow.unit_offset >= self.end_of_path:
		var action:String = path.at_end_of_path()
		if action == "free":
			queue_free()
		elif action == "stop":
			motor.emitting = false
			speed = 0.0
		elif action == "stop and shoot":
			motor.emitting = false
			speed = 0.0
			self.allow_shoot = true



func check_mid_of_path() -> void:
	pass


func get_random_explosion_sfx() -> void:
	randomize()
	var rand = int(rand_range(0, explosions_sfx.size()))
	var rand_sfx = load(explosions_sfx[rand])
	explosion_sfx.stream = rand_sfx

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") and can_take_damage:
		take_damage(area.get_damage())


func take_damage(damage: float) -> void:
	hitpoints -= damage
	#sprite.modulate = sprite.modulate.linear_interpolate(Color(1.0, 0.0, 0.0, 1.0), hitpoints * 0.001)
	if hitpoints <= 0:
		can_take_damage = false
		emit_signal("enemy_destroyed")
		animation_player.play("destroy")
	else:
		animation_player_2.play("impact")
		hit_sfx.play()

func play_explosion_sfx() -> void:
	explosion_sfx.play()
	explosion_vfx.play("explosion")

func disabled_collider() -> void:
	self.allow_shoot = false
	damage_collider.set_deferred("disabled", true)
