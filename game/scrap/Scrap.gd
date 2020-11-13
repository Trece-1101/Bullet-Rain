class_name Scrap
extends Area2D

#### Variables
var scrap_color := Color.white
var freq := 4.0
var amplitude = 200.0
var speed := Vector2(20.0, 50.0)
var time := 0.0
var reward := 0

#### Metodos
func _physics_process(delta: float) -> void:
	time += delta
	speed.x = cos(time * freq) * amplitude
	position += speed * delta
 
func create(_pos: Vector2, _reward: int) -> void:
	global_position = _pos
	reward = _reward

func _on_body_entered(body: Node) -> void:
	$ConsumeSFX.play()
	set_physics_process(false)
	$PlayerDetector.set_deferred("disabled", true)
	GlobalData.add_scrap(reward)
	$AnimationPlayer.stop()
	if not body == null:
		_consume_animation(body)

func _consume_animation(body: Node) -> void:
	$Tween.interpolate_property(
		self,
		"global_position",
		global_position,
		body.global_position,
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	queue_free()
