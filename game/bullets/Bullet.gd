class_name Bullet, "res://assets/bullets/enemy_bullet_temp.png"
extends Area2D

#### Variables Export
export(Color, RGBA) var bullet_color_one := Color.red
export(Color, RGBA) var bullet_color_alt := Color.yellow
export(Color, RGBA) var bullet_color_indestructible := Color.purple

#### Variables
var velocity := Vector2.ZERO
var type := 1 setget ,get_type
var damage: float setget ,get_damage
var creater: Object

#### Variables onready
onready var bullet_sprite := $Sprite
onready var destroy_sound := $DestroySFX

#### Setters y Getters
func get_damage() -> float:
	return damage

func get_type() -> int:
	return type

#### Metodos
func create(
		bullet_creater: Object,
		bullet_pos: Vector2,
		bullet_speed: float,
		bullet_dir: float,
		bullet_type: int,
		bullet_damage := 1.0,
		bullet_angle := 0.0
	) -> void:
	creater = bullet_creater
	position = bullet_pos
	rotation = bullet_dir
	velocity = Vector2(0.0, bullet_speed).rotated(deg2rad(bullet_angle))
	type = bullet_type
	damage = bullet_damage


func _ready() -> void:
	match type:
		-1:
			bullet_sprite.modulate = bullet_color_alt
		1:
			bullet_sprite.modulate = bullet_color_one
		0:
			bullet_sprite.modulate = bullet_color_indestructible
		_:
			print("ERROR")




func _process(delta: float) -> void:
	position += velocity * delta
	if creater is EnemyBase:
		bullet_sprite.rotation += 2 * PI * delta / 4


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		var other_bullet:Bullet = area
		if other_bullet.get_type() == type:
			other_bullet.destroy()
			destroy()
	else:
		destroy()
		#queue_free()


func destroy() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	$AnimationPlayer.play("impact")
	
func destroy_sfx() -> void:
	destroy_sound.play()
