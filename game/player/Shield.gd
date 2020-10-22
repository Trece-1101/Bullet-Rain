extends Area2D

export var grow_rate = 100.0
export var is_power_upper := false

func _ready() -> void:
	$CollisionShape2D.shape.radius = 0.1
	set_process(false)

func _process(delta: float) -> void:
	change_size(grow_rate * delta)

func change_size(value: float) -> void:
	$CollisionShape2D.shape.radius += value

func _on_area_entered(area: Area2D) -> void:
	area.destroy()
