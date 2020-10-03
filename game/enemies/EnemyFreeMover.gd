class_name EnemyFreeMover
extends EnemyFree

export(float, 0.5, 1.5) var free_speed := 1.2

onready var tween := $Tween

func make_your_move(new_position: Vector2) -> void:
	tween.interpolate_property(
		self,
		"global_position",
		global_position,
		new_position,
		free_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	self.new_position_timer.start()
