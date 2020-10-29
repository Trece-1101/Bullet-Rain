class_name Ultimate
extends Node

var ultimate_duration := 4.0
var ult_timer: Timer
var parent: KinematicBody2D

func _ready() -> void:
	parent = get_parent()
	ult_timer = Timer.new()
	ult_timer.wait_time = ultimate_duration
	ult_timer.one_shot = true
	ult_timer.connect("timeout", self, "end_ultimate")
	add_child(ult_timer)

func use_ultimate() -> void:
	pass

func end_ultimate() -> void:
	pass
