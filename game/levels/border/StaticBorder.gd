extends StaticBody2D

#### Variables export
export var left_border := 320.0
export var right_border := 1600.0


#### Metodos
func _ready() -> void:
	$Left.global_position.x = left_border
	$Right.global_position.x = right_border
