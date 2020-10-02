class_name EnemyKamikaze
extends EnemyBase

export var dive_speed := 1.5
export var stop_before_dive := 0.8

var is_at_end := false
var player_pos := Vector2.ZERO

onready var player_destroyer := $PlayerDestroyer/CollisionShape2D


func _process(_delta: float) -> void:
	if not player == null:
		check_aim_to_player()


func check_end_of_path() -> void:
	if follow.unit_offset >= self.end_of_path and not is_at_end:
		is_at_end = true
		yield(get_tree().create_timer(stop_before_dive), "timeout")
		go_kamikaze()


func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	rotation = rot_look


func go_kamikaze() -> void:
	set_process(false)
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


func play_explosion() -> void:
	$Explosion2/ExplosionPlayer.play("explosion")


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	play_explosion()
	player_destroyer.set_deferred("disabled", false)
	$Sprite.visible = false
	self.motor.visible = false
	self.damage_collider.set_deferred("disabled", true)

func _on_ExplosionPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "explosion":
		queue_free()


func _on_PlayerDestroyer_body_entered(body: Node) -> void:
	if body is Player:
		body.die()
