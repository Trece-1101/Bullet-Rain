class_name EnemyPart
extends Area2D

#### Señales
signal destroyed

#### Variables export
export var hitpoints := 50.0
export var bullet_speed := 400
export var bullet: PackedScene setget ,get_bullet
export var bomb: PackedScene
export(Array, NodePath) var indestructible_bullets

#### Variables
var can_shoot := false setget set_can_shoot, get_can_shoot
var can_shoot_bomb := false setget set_can_shoot_bomb, get_can_shoot_bomb
var explosion_limits := Vector2.ZERO
var can_take_damage := true

#### Variables onready
onready var mini_explosion_vfx := $ExplosionFire2
onready var hit_sfx := $HitSFX
onready var gun_timer := $GunTimer
onready var bomb_timer := $BombTimer
onready var shoot_positions := $ShootPositions
onready var shoot_sfx := $ShootSFX

#### Setters y getters
func set_can_shoot(value: bool) -> void:
	can_shoot = value

func get_can_shoot() -> bool:
	return can_shoot

func set_can_shoot_bomb(value: bool) -> void:
	can_shoot_bomb = value

func get_can_shoot_bomb() -> bool:
	return can_shoot_bomb

func get_bullet() -> PackedScene:
	return bullet

#### Metodos
func _ready() -> void:
	#can_shoot = true
	explosion_limits = $Sprite.texture.get_size() * 0.4
	if indestructible_bullets.size() > 0:
		set_indestructible_bullet()

func _process(_delta: float) -> void:
	if can_shoot:
		shoot()
	
	if can_shoot_bomb:
		shoot_bomb()

func set_indestructible_bullet() -> void:
	for path in indestructible_bullets:
		get_node(path).set_bullet_type(0)

func _on_area_entered(area: Area2D) -> void:
	if can_take_damage:
		take_damage(area.get_damage())

func _on_body_entered(body: Node) -> void:
	body.die()

func take_damage(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		can_take_damage = false
		die()
	else:
		randomize()
		var pos_x := rand_range(-explosion_limits.x, explosion_limits.x)
		var pos_y := rand_range(-explosion_limits.y, explosion_limits.y)
		mini_explosion_vfx.position = Vector2(pos_x, pos_y)
		mini_explosion_vfx.get_node("ExplosionPlayer").play("explosion")
		hit_sfx.play()

func shoot() -> void:
	can_shoot = false
	self.gun_timer.start()
	self.shoot_sfx.play()
	for shoot_position in shoot_positions.get_children():
		shoot_position.shoot_bullet(
			bullet_speed,
			0.0,
			shoot_position.get_bullet_type(),
			1.0,
			0.0
		)

func shoot_bomb() -> void:
	can_shoot_bomb = false
	bomb_timer.start()
	var new_bomb := bomb.instance()
	new_bomb.global_position = $BombPosition.position
	add_child(new_bomb)

func die() -> void:
	can_shoot = false
	emit_signal("destroyed")
	$AnimationPlayer.play("destroyed")


func die_from_boss() -> void:
	can_shoot = false
	$AnimationPlayer.play("destroyed")


func _on_GunTimer_timeout() -> void:
	can_shoot = true


func _on_BombTimer_timeout() -> void:
	can_shoot_bomb = true
