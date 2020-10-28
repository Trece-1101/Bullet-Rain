class_name UltimateStealth
extends Ultimate

var parent: KinematicBody2D

func use_ultimate() -> void:
	print("ultimate stealth")
	var ult_timer := Timer.new()
	ult_timer.wait_time = 4.0
	ult_timer.one_shot = true
	ult_timer.connect("timeout", self, "end_ultimate")
	add_child(ult_timer)
	
	parent = get_parent()
	parent.set_is_in_god_mode(true)
	ult_timer.start()

func end_ultimate() -> void:
	parent.set_is_in_god_mode(false)
