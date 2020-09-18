extends Area2D
class_name Bullet

#### Variables Export
export var damage := 20.0
export var speed := 300.0

#### Variables
var velocity := Vector2.ZERO

func get_damage() -> float:
	return damage


#### Metodos
func create(pos: Vector2, dir: float, angle: float = 0.0) -> void:
	position = pos
	rotation = dir
	velocity = Vector2(angle, speed)


func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node) -> void:
	die()


func _on_VisibilityNotifier2D_screen_exited():
	pass
	#die()


func _on_area_entered(area):
	die()


func die() -> void:
	queue_free()
