class_name EnemyFree
extends EnemyBandit

#### Variables Export
export var teletransportation_rate := 1.2
export(int, FLAGS, "LU", "LD", "RU", "RD") var cuadrant := 0

#### Variables
var is_at_end := false
var limits := {"left": 0.0, "right": 0.0, "up": 0.0, "down": 0.0}

#### Variables Onready
onready var new_position_timer := $NewPositionTimer
onready var sprite_teleport_ring := $SpriteTeleportRing
onready var animation_teleport := $AnimationTeleport

#### Metodos
func _ready() -> void:
	sprite_teleport_ring.set_as_toplevel(true)
	check_cuadrant()
	new_position_timer.wait_time = teletransportation_rate
	set_physics_process(false)

func _process(_delta: float) -> void:
	aim_to_player()

func _physics_process(_delta: float) -> void:
	aim_to_player()
	if can_shoot and self.allow_shoot and self.inside_play_screen:
		shoot()

func check_cuadrant() -> void:
	match cuadrant:
		1: 
			limits.left = 560.0
			limits.right = 960.0
			limits.up = 140.0
			limits.down = 600.0
		2:
			limits.left = 560.0
			limits.right = 960.0
			limits.up = 370.0
			limits.down = 600.0
		3:
			limits.left = 560.0
			limits.right = 960.0
			limits.up = 140.0
			limits.down = 600.0
		4:
			limits.left = 960.0
			limits.right = 1360.0
			limits.up = 140.0
			limits.down = 370.0
		5:
			limits.left = 560.0
			limits.right = 1360.0
			limits.up = 140.0
			limits.down = 370.0
		8:
			limits.left = 960.0
			limits.right = 1360.0
			limits.up = 140.0
			limits.down = 370.0
		10:
			limits.left = 560.0
			limits.right = 1360.0
			limits.up = 370.0
			limits.down = 600.0
		12:
			limits.left = 960.0
			limits.right = 1360.0
			limits.up = 140.0
			limits.down = 600.0
		_:
			limits.left = 560.0
			limits.right = 1360.0
			limits.up = 140.0
			limits.down = 600.0


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
	new_position_timer.start()

func choose_new_position() -> Vector2:
	randomize()
	var new_position_x := rand_range(limits.left, limits.right)
	var new_position_y := rand_range(limits.up, limits.down)
	return Vector2(new_position_x, new_position_y)

func die() -> void:
	.die()
	animation_teleport.play("init")
	new_position_timer.stop()
	self.gun_timer.stop()
	set_physics_process(false)
	self.can_shoot = false


func _on_NewPositionTimer_timeout() -> void:
	if self.is_alive:
		var new_position := choose_new_position()
		sprite_teleport_ring.global_position = new_position
		animation_teleport.play("spawn_ring")
		yield(get_tree().create_timer(0.4), "timeout")
		global_position = new_position
		new_position_timer.start()
