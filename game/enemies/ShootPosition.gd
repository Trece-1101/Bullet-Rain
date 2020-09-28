class_name ShootPosition
extends Position2D

#### Variables Export
export var bullet_angle := 0.0

#### Variables Onready
onready var bullet_type := -1


#### Setters y Getters
func get_bullet_angle () -> float:
	return bullet_angle

func get_bullet_type() -> int:
	return bullet_type



