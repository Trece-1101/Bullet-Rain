class_name EnemyFree
extends EnemyBandit

export var free_speed := 250.0

var is_at_end := false

onready var new_position_timer := $NewPositionTimer


func _ready() -> void:
	set_physics_process(false)

func _process(_delta: float) -> void:
	aim_to_player()

func _physics_process(_delta: float) -> void:
	aim_to_player()
	if can_shoot and self.allow_shoot and self.inside_play_screen:
		shoot()
	
	

func aim_to_player() -> void:
	if not player == null:
		check_aim_to_player()

func check_end_of_path() -> void:
	if follow.unit_offset >= self.end_of_path and not is_at_end:
		is_at_end = true
		go_free_mode()

func go_free_mode() -> void:
	set_process(false)
	set_physics_process(true)
	self.speed = free_speed
	new_position_timer.start()

func choose_new_position() -> Vector2:
	randomize()
	# Izq_superior [580, 140]
	# Der_superior [1340, 140]
	# Izq_inferior [580, 430]
	# Der_inferior [1340, 430]
	var new_position_x := rand_range(580, 1341)
	var new_position_y := rand_range(140, 431)
	return Vector2(new_position_x, new_position_y)



func _on_NewPositionTimer_timeout() -> void:
	global_position = choose_new_position()
	new_position_timer.start()
