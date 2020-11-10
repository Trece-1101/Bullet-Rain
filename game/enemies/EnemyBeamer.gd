class_name EnemyBeamer
extends Area2D

#### Variables export
export var time_to_live := 8.0
export var speed := 10.0
export var rotation_speed := 10.0

#### Variables onready
onready var lasers := $Lasers

#### Metodos
func _ready() -> void:
	$TimeToLiveTimer.wait_time = time_to_live

func cast_lasers(value: bool) -> void:
	for laser in lasers.get_children():
		laser.set_is_casting(value)

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	position.x += speed * delta

func _start_timer() -> void:
	$TimeToLiveTimer.start()

func _on_TimeToLiveTimer_timeout() -> void:
	$AnimationPlayer.play("despawn")
