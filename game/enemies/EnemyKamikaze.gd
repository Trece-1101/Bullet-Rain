class_name EnemyKamikaze
extends EnemyPather

#### Variables export
export var dive_speed := 1.5
export var stop_before_dive := 0.8

#### Variables
var is_at_end := false
var player_pos := Vector2.ZERO
#var is_alive := true

#### Variables Onready
onready var player_destroyer := $PlayerDestroyer/CollisionShape2D


#### Metodos
func _process(_delta: float) -> void:
	if player != null and is_alive:
		check_aim_to_player()


func check_end_of_path() -> void:
	if follow.unit_offset >= self.end_of_path and not is_at_end:
		is_at_end = true
		$TimerStopper.start()



func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	rotation = rot_look


func go_kamikaze() -> void:
	set_process(false)
	if player != null:
		player_pos = self.player.global_position
		$Tween.interpolate_property(
			self,
			"global_position",
			global_position,
			player_pos,
			dive_speed,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		make_the_despelote()


func play_explosion() -> void:
	$ExplosionFire2/ExplosionPlayer.play("explosion")


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	make_the_despelote()

func make_the_despelote() -> void:
	play_explosion()
	player_destroyer.set_deferred("disabled", false)
	$TimerDestroyer.start()
	die()

func _on_ExplosionPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "explosion":
		queue_free()


func _on_PlayerDestroyer_body_entered(body: Node) -> void:
	if body is Player:
		body.die()

func die() -> void:
	.die()
	$Tween.stop_all()


func _on_TimerDestroyer_timeout() -> void:
	player_destroyer.set_deferred("disabled", true)


func _on_TimerStopper_timeout() -> void:
	if self.is_alive:
		go_kamikaze()
