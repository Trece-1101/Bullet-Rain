extends Area2D
class_name Bullet

#### Variables Export
export var damage := 20.0
export var speed := 300.0

#### Variables
var velocity := Vector2.ZERO
var type := 1

func get_damage() -> float:
	return damage

func get_type() -> int:
	return type

#### Metodos
func create(
	bullet_pos: Vector2,
	bullet_dir: float,
	bullet_angle: float,
	bullet_type: int
	) -> void:
	position = bullet_pos
	rotation = bullet_dir
	velocity = Vector2(bullet_angle, speed)
	type = bullet_type

func _ready() -> void:
	if type == 1:
		$Sprite.modulate = Color.red
	else:
		$Sprite.modulate = Color.yellow


func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node) -> void:
	destroy()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()


func _on_area_entered(area):
	destroy()


func destroy() -> void:
	queue_free()
