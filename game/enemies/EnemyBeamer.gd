extends Area2D

onready var laser:LaserBeam = $LaserBeam2D

func _ready() -> void:
	laser.is_casting = true

func _process(delta: float) -> void:
	rotation_degrees += 5 * delta
