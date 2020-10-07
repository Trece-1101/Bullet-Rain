class_name EnemyOrbital
extends EnemyBase

export var angle := 0.0
export var distance := 150

var leader: EnemyBase
var rot_center := Vector2.ZERO

func _ready() -> void:
	leader = get_parent()

func _process(delta: float) -> void:
	if leader != null:
		global_position = leader.global_position + Vector2(cos(angle), sin(angle)) * distance
		angle += speed * delta

func die() -> void:
	is_alive = false
	can_take_damage = false
	animation_player.play("destroy")
