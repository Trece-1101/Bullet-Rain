extends StaticBody2D

export var left_border := 320.0
export var right_border := 1600.0

func _ready() -> void:
	$Left.global_position.x = left_border
	$Right.global_position.x = right_border
