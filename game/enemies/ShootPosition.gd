class_name ShootPosition
extends Position2D

#### Variables Export
export var bullet_angle := 0.0
export(int, -1, 1) var bullet_type := 1


#### Setters y Getters
func get_bullet_angle () -> float:
	return bullet_angle

func get_bullet_type() -> int:
	return bullet_type


#### Metodos
func _ready() -> void:
	if bullet_type == 0:
		bullet_type = 1