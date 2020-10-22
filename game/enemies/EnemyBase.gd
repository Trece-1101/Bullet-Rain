class_name EnemyBase
extends Area2D


#### Variables Export
export var hitpoints := 50.0
export var speed := 0.0 setget set_speed
export var is_boss := false setget ,get_is_boss

#### Variables
var can_take_damage := true
var player: Player
var is_alive := true

var allow_shoot := false setget set_allow_shoot, get_allow_shoot
var inside_play_screen := false setget set_inside_play_screen, get_inside_play_screen

var explosion_limits := Vector2.ZERO
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
onready var explosion_vfx := $ExplosionFire/ExplosionPlayer
onready var mini_explosion_vfx := $ExplosionFire2
onready var sprite := $Sprite

#### Setters y Getters
func set_speed(value: float) -> void:
	speed = value

func set_allow_shoot(value: bool) -> void:
	allow_shoot = value

func get_allow_shoot() -> bool:
	return allow_shoot

func set_inside_play_screen(value: bool) -> void:
	inside_play_screen = value

func get_inside_play_screen() -> bool:
	return inside_play_screen

func get_is_boss() -> bool:
	return is_boss

#### Metodos
func _ready() -> void:
	set_explosion_vars()
# warning-ignore:return_value_discarded
	get_top_level().connect("get_new_player", self, "player_respawn")
# warning-ignore:return_value_discarded
	get_top_level().connect("wait_new_player", self, "wait")

# warning-ignore:unused_argument
func wait(time_to_wait: float) -> void:
	pass

func set_explosion_vars() -> void:
	explosion_limits = sprite.texture.get_size() * 0.4
	get_random_explosion_sfx()

func _process(_delta: float) -> void:
	pass

func get_top_level() -> Node:
	var parent := get_parent()
	while not "GameLevel" in parent.name:
		parent = parent.get_parent()
	
	return parent

func player_respawn() -> void:
	allow_shoot = true
	get_player()

func get_player() -> void:
	for child in get_top_level().get_children():
		if child is Player:
			player = child
			break


func get_random_explosion_sfx() -> void:
	randomize()
	var rand = int(rand_range(0, explosions_sfx.size()))
	var rand_sfx = load(explosions_sfx[rand])
	explosion_sfx.stream = rand_sfx

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") and can_take_damage:
		take_damage(area.get_damage())


func _on_body_entered(body: Node) -> void:
	body.die()
	if not is_boss:
		die()

func take_damage(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		die()
	else:
		randomize()
		var pos_x := rand_range(-explosion_limits.x, explosion_limits.x)
		var pos_y := rand_range(-explosion_limits.y, explosion_limits.y)
		mini_explosion_vfx.position = Vector2(pos_x, pos_y)
		mini_explosion_vfx.get_node("ExplosionPlayer").play("explosion")
		hit_sfx.play()


func die() -> void:
	pass


func play_explosion_sfx() -> void:
	explosion_sfx.play()
	explosion_vfx.play("explosion")


func disabled_collider() -> void:
	self.allow_shoot = false
	for child in get_children():
		if child.is_in_group("damage_collider"):
			child.set_deferred("disabled", true)

