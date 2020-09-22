class_name Bullet
extends Area2D


#### Variables
var velocity := Vector2.ZERO
var type := 1
var damage: float

func get_damage() -> float:
	return damage

func get_type() -> int:
	return type

#### Metodos
func create(
		bullet_pos: Vector2,
		bullet_speed: float,
		bullet_dir: float,
		bullet_type: int,
		bullet_damage := 1.0,
		bullet_angle := 0.0
		) -> void:
	position = bullet_pos
	rotation = bullet_dir
	velocity = Vector2(0.0, bullet_speed).rotated(deg2rad(bullet_angle))
	type = bullet_type
	damage = bullet_damage
	
  

func _ready() -> void:
	if type == 1:
		$Sprite.modulate = Color.red
	else:
		$Sprite.modulate = Color.yellow


func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage()
	destroy()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()


func _on_area_entered(area) -> void:
	if "Bullet" in area.name:
		var other_bullet_type: int = area.get_type()
		if other_bullet_type == type:
			area.destroy()
			destroy()
	else:
		destroy()


func destroy() -> void:
	queue_free()
