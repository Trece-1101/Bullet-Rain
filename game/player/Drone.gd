class_name Drone
extends Area2D

signal end_drone

func _start_shield() -> void:
	$Shield/AnimationPlayer.play("drone_respawning")

func ending_time() -> void:
	emit_signal("end_drone")
