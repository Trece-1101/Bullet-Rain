class_name EnemyBossBT
extends EnemyBase

#### Señales
signal destroy()

#### Variables export
export var bullet: PackedScene
export var bullet_speed := 400.0
export var test_shoot := false
export(Array, NodePath) var indestructible_bullets
export var start_position := Vector2.ZERO
export var defense_position := Vector2.ZERO
export var defense_time := 5.0
export var shoot_rate := 1.0
export var bomb_shoot_rate := 1.0
export var is_aimer := true
export var minions_spawn_delay := 2.0
export(Array, PackedScene) var normal_minions
export(Array, PackedScene) var critic_minions

#### Variables
var original_hitpoints: float
var bullet_rot_correction := 0.0
var is_shooting := false
var original_speed := 0.0
var can_shoot := false setget set_can_shoot, get_can_shoot
var current_shoot_positions_shooting: Node2D
var shield := preload("res://game/enemies/EnemyShield.tscn")
var bomb := preload("res://game/bullets/Bomb.tscn")

#### Variables Onready
onready var gun_timer := $GunTimer
onready var wait_timer := $WaitTimer
onready var bomb_timer := $BombTimer
onready var shoot_sfx := $ShootSFX
onready var rotation_tween := $RotationTween
onready var movement_tween := $MovementTween
onready var minions_positions := $MinionsPositions


#### Blackboard
onready var blackboard := {
	"tresholds": {
		0: ["high_life", 0.85],
		1: ["mid_life", 0.65],
		2: ["low_life", 0.35], 
		3: ["critic_life", 0.20],
		4: ["dead_life", 0.0]
	},
	"current_treshold": 0,
	"shoot_positions_container": {
		1: [$ShootPositions1, bullet_speed, shoot_rate],
		2: [$ShootPositions2, bullet_speed * 0.8, shoot_rate * 0.9], 
	},
	"current_shoot_stage": 1,
	"defense_mode": {
		"time": defense_time,
		"time_over": false,
	},
	"current_movement_stage": 1,
	"movement_type": {1: {}}
}

#### Setters y Getters
func set_can_shoot(value: bool) -> void:
	can_shoot = value

func get_can_shoot() -> bool:
	return can_shoot

func get_bullet() -> PackedScene:
		return bullet

#### Metodos
func _ready() -> void:
	$DefensiveBT.enable = false
	$OffensiveBT.enable = true
	original_hitpoints = hitpoints
	original_speed = self.speed
	global_position = start_position
	can_shoot = true
	self.allow_shoot = true
	gun_timer.wait_time = shoot_rate
	bomb_timer.wait_time = bomb_shoot_rate
	wait_timer.wait_time = blackboard.defense_mode.time
	get_player()
	current_shoot_positions_shooting = blackboard.shoot_positions_container[blackboard.current_shoot_stage][0]
	if indestructible_bullets.size() > 0:
		set_indestructible_bullet()

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if is_aimer and not player == null and is_alive:
		check_aim_to_player()
	
	if can_shoot and self.allow_shoot:
		shoot(current_shoot_positions_shooting)

func shoot(shoot_positions: Node2D) -> void:
	if not can_shoot:
		return
	
	shoot_sfx.play()
	can_shoot = false
	gun_timer.start()
	for shoot_position in shoot_positions.get_children():
		shoot_position.shoot_bullet(
			bullet_speed,
			0.0,
			shoot_position.get_bullet_type(),
			1.0,
			bullet_rot_correction
		)

func shoot_bomb() -> void:
	shoot_sfx.play()
	for pos in $BombPositions.get_children():
		var new_bomb := bomb.instance()
		new_bomb.global_position = pos.global_position
		get_parent().add_child(new_bomb)
	
	bomb_timer.start()

func set_indestructible_bullet() -> void:
	for path in indestructible_bullets:
		get_node(path).set_bullet_type(0)

func add_shoot_positions_to_container(
		key: int,
		shoot_positions: Node2D,
		b_speed:float = bullet_speed,
		s_rate:float = shoot_rate) -> void:
	blackboard.shoot_positions_container[key] = [shoot_positions, b_speed, s_rate]


func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look)
	bullet_rot_correction = rad2deg(rot) - 90.0
	rotation_degrees = my_rotation

func check_aim_to_center() -> float:
#	var dir = Vector2(960.0, 920.0) - global_position
	var dir = Vector2.DOWN
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look)
	bullet_rot_correction = rad2deg(rot) - 90.0
	return my_rotation

func look_at_center() -> void:
	rotation_tween.interpolate_property(
		self,
		"rotation_degrees",
		rotation_degrees,
		check_aim_to_center(),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	rotation_tween.start()

func move_to_position(new_pos: Vector2) -> void:
	movement_tween.interpolate_property(
		self,
		"global_position",
		global_position,
		new_pos,
		2.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	movement_tween.start()

func _on_MovementTween_tween_all_completed() -> void:
	if $OffensiveBT.enable:
		set_physics_process(true)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func spawn_minions(critic: bool, type: int) -> void:
#	print("es critico: {c} y del tipo {t}".format({"c": critic, "t": type}))
	pass

# warning-ignore:unused_argument
func manage_move_stages(move_stage: int) -> void:
	pass

func die() -> void:
	set_physics_process(false)
	for laser in $Lasers.get_children():
		laser.queue_free()
	$OffensiveBT.enable = false
	$DefensiveBT.enable = false
	is_aimer = false
	can_shoot = false
	gun_timer.stop()
	wait_timer.stop()
	bomb_timer.stop()
	is_alive = false
	animation_player.play("ultra_destroy")
	emit_signal("destroy")

func _on_GunTimer_timeout() -> void:
	can_shoot = true

func _on_WaitTimer_timeout() -> void:
	blackboard.defense_mode.time_over = true

func _on_BombTimer_timeout() -> void:
	shoot_bomb()

#### Tareas
func task_say_my_life(task) -> void:
	print("{hp} - {life}".format({"hp": hitpoints, "life": blackboard.tresholds[blackboard.current_treshold][0]}))
	task.succeed()

func task_is_below_threshold(task) -> void:
	if hitpoints < original_hitpoints * blackboard.tresholds[blackboard.current_treshold][1]:
		if blackboard.current_treshold < blackboard.tresholds.size() - 1:
			blackboard.current_treshold += 1
		task.succeed()
	else:
		task.failed()

func task_next_shoot_stage(task) -> void:
	blackboard.current_shoot_stage += 1
	var shoot_stage:int = blackboard.current_shoot_stage
	if shoot_stage > blackboard.shoot_positions_container.size():
		shoot_stage = blackboard.shoot_positions_container.size()
	current_shoot_positions_shooting = blackboard.shoot_positions_container[shoot_stage][0]
	bullet_speed = blackboard.shoot_positions_container[shoot_stage][1]
	gun_timer.wait_time = blackboard.shoot_positions_container[shoot_stage][2]
	task.succeed()

func task_next_move_stage(task) -> void:
	blackboard.current_movement_stage += 1
	var move_stage:int = blackboard.current_movement_stage
	if move_stage > blackboard.movement_type.size():
		move_stage = blackboard.movement_type.size()
	manage_move_stages(move_stage)
	task.succeed()

func task_set_defense_mode(task) -> void:
	set_physics_process(false)
	$OffensiveBT.enable = false
	$DefensiveBT.enable = true
	wait_timer.start()
	task.succeed()

func task_set_offensive_mode(task) -> void:
	$DefensiveBT.enable = false
	$OffensiveBT.enable = true
	blackboard.defense_mode.time_over = false
	task.succeed()

func task_toggle_aim(task) -> void:
	if task.get_param(0) == "true":
		is_aimer = true
	else:
		is_aimer = false
		look_at_center()
	
	task.succeed()

func task_disable_shooting(task) -> void:
	allow_shoot = false
	gun_timer.stop()
	task.succeed()

func task_enable_shooting(task) -> void:
	allow_shoot = true
	can_shoot = true
	task.succeed()

func task_enable_shoot_bomb(task) -> void:
	bomb_timer.start()
	task.succeed()

func task_disabled_shoot_bomb(task) -> void:
	bomb_timer.stop()
	task.succeed()

func task_has_shield(task) -> void:
	for child in get_children():
		if child is EnemyShield:
			task.succeed()
			return
	task.failed()

func task_set_shield(task) -> void:
	var size = task.get_param(0)
	var new_shield := shield.instance()
	new_shield.position = $ShieldPosition.position
	new_shield.scale = Vector2(size, size)
	new_shield.name = "EnemyShield"
	add_child(new_shield)
	task.succeed()

func task_disabled_shield(task) -> void:
	if get_node_or_null("EnemyShield") != null:
		get_node_or_null("EnemyShield").queue_free()
	task.succeed()

func task_disabled_shield_with_delay(task) -> void:
	if get_node_or_null("EnemyShield") != null:
		if not get_node_or_null("EnemyShield").is_deactivating:
			get_node_or_null("EnemyShield").disable_with_delay()
	task.succeed()


func task_move_to_defense_position(task) -> void:
	move_to_position(defense_position)
	task.succeed()

func task_move_to_start_position(task) -> void:
	move_to_position(start_position)
	task.succeed()

func task_is_critic(task) -> void:
	if blackboard.tresholds[blackboard.current_treshold][0] in ["dead_life", "critic_life"]:
		task.succeed()
	else:
		task.failed()

func task_is_dead_critic(task) -> void:
	if blackboard.tresholds[blackboard.current_treshold][0] in ["dead_life"]:
		task.succeed()
	else:
		task.failed()

func task_is_defense_time_over(task) -> void:
	if blackboard.defense_mode.time_over:
		task.succeed()
	else:
		task.failed()

func task_spawn_minion(task) -> void:
	var critic = task.get_param(0)
	var type = task.get_param(1)
	if critic:
		spawn_minions(false, type)
	else:
		spawn_minions(true, type)
	
	task.succeed()

func task_enable_lasers(task) -> void:
	for laser in $Lasers.get_children():
		if not laser.get_is_casting():
			laser.set_is_casting(true)
	task.succeed()

func task_player_to_close(task) -> void:
	if player != null:
		if abs($ShieldPosition.global_position.y - player.global_position.y) < 250.0:
			task.succeed()
		else:
			task.failed()
	else:
		task.failed()





