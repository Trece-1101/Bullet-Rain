class_name EnemyPart
extends Area2D

#### Señales
signal destroyed
signal half_life


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
var shield := preload("res://game/enemies/EnemyShield.tscn")
var original_hitpoints := 0.0
var half_life := false
var is_alive := true setget ,get_is_alive


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

func get_is_alive() -> bool:
	return is_alive

#### Metodos
func _ready() -> void:
	original_hitpoints = hitpoints
	explosion_limits = $Sprite.texture.get_size() * 0.4
	if indestructible_bullets.size() > 0:
		set_indestructible_bullet()

func _process(_delta: float) -> void:
	if hitpoints <= (original_hitpoints * 0.5) and not half_life:
		half_life = true
		emit_signal("half_life")
	
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

func spawn_shield(size := 1.0) -> void:
	var new_shield := shield.instance()
	new_shield.position = $ShieldPosition.position
	new_shield.scale = Vector2(size, size)
	new_shield.name = "PartShield"
	add_child(new_shield)

func destroy_shield() -> void:
	if get_node_or_null("PartShield") != null:
		get_node("PartShield").queue_free()

func toogle_shooting(type: String, value) -> void:
	match type:
		"bullet":
			can_shoot = value
			if not value:
				gun_timer.stop()
		"bomb":
			can_shoot_bomb = value
			if not value:
				bomb_timer.stop()
		_:
			pass

func die() -> void:
	is_alive = false
	emit_signal("destroyed")
	die_from_boss()

func die_from_boss() -> void:
	set_process(false)
	bomb_timer.stop()
	gun_timer.stop()
	can_shoot = false
	can_shoot_bomb = false
	
	if get_node_or_null("PartShield") != null:
		get_node("PartShield").queue_free()
	
	for child in get_children():
		if child is Bomb:
			child.destroy()
	$AnimationPlayer.play("destroyed")


func _on_GunTimer_timeout() -> void:
	can_shoot = true

func _on_BombTimer_timeout() -> void:
	can_shoot_bomb = true
