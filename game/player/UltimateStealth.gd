class_name UltimateStealth
extends Ultimate

func use_ultimate() -> void:
	parent.set_is_in_god_mode(true)
	ult_timer.start()

func end_ultimate() -> void:
	parent.set_is_in_god_mode(false)
