extends Camera2D

export var decay := 0.5
export var max_offset := Vector2(100.0, 100.0)
export var max_roll := 0.1
export (NodePath) var target

var trauma := 0
var trauma_power := 2

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)

func add_trauma(value: float) -> void:
	trauma = min(trauma + value, 1.0)
