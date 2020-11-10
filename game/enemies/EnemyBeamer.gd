class_name EnemyBeamer
extends Area2D

### Señales
signal end_life

#### Variables export
export var time_to_live := 8.0 setget ,get_time_to_live
export var speed := Vector2(10.0, 0.0)
export var rotation_speed := 10.0
export var start_position := Vector2(960.0, 400.0)

#### Variables onready
onready var lasers := $Lasers

#### Setters y Getters
func get_time_to_live() -> float:
	return time_to_live

#### Metodos
func _ready() -> void:
	global_position = start_position
	$TimeToLiveTimer.wait_time = time_to_live

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	position += speed * delta

func cast_lasers(value: bool) -> void:
	for laser in lasers.get_children():
		laser.set_is_casting(value)

func _start_timer() -> void:
	$TimeToLiveTimer.start()

func _on_TimeToLiveTimer_timeout() -> void:
	emit_signal("end_life")
	$AnimationPlayer.play("despawn")
