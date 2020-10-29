extends Area2D

#### Variables export
export var grow_rate = 100.0
export var is_power_upper := false

#### Variables onready
onready var collider := $BulletSponge

func _ready() -> void:
	restart_size()
	set_process(false)


func _process(delta: float) -> void:
	collider.shape.radius += grow_rate * delta


func restart_size() -> void:
	collider.shape.radius = 0.05


func _on_area_entered(area: Area2D) -> void:
	area.destroy()
