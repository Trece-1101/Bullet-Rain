class_name EnemyRotator
extends EnemyShooter

#### Variables Export
export var rotation_speed := 100.0

#### Setters y Getters
func set_is_aimer(_value: bool) -> void:
	self.is_aimer = false


#### Metodos
func _ready() -> void:
	self.is_aimer = false
	self.can_shoot = true


func _process(delta: float):
	rotation_degrees += rotation_speed * delta
	self.bullet_rot_correction = rotation_degrees
