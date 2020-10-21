class_name EnemyRotator
extends EnemyShooter

#### Variables Export
export var rotation_speed := 100.0
export var rotation_offset := 1.0

#### Setters y Getters
func set_is_aimer(_value: bool) -> void:
	is_aimer = false


#### Metodos
func _ready() -> void:
	self.is_aimer = false


func _process(delta: float):
	rotation_degrees += rotation_speed * delta
	self.bullet_rot_correction = rotation_degrees * rotation_offset


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		animation_player.play("turn_off_engine")
