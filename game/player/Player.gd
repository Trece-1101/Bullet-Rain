extends KinematicBody2D
class_name Player

#### Enumerables
enum States { INIT, IDLE, RESPAWNING, MOVING, SHOOTING, GOD, DEAD }

#### Variables Export
export var speed := 200.0
export var bullet: PackedScene
export(float, 0.15, 0.32) var shooting_rate := 0.2
export var hitpoints := 4

#### Variables
var state = States.INIT
var state_text := "INIT"
var can_shoot := true
var speed_multiplier := 0.8
var speed_using := 0.0
var speed_shooting: float
var speed_respawning := 0

#### Variables Onready
onready var bullet_container: Node
onready var shoot_positions := $ShootPositions
onready var gun_timer := $GunTimer
onready var movement := Vector2.ZERO

#### Setters y Getters
func set_movement(value: Vector2) -> void:
	movement = value

func get_movement() -> float:
	return movement.length()

func get_shoot_rate() -> float:
	return gun_timer.wait_time

func get_state() -> String:
	return state_text


#### Metodos
func _ready() -> void:
	change_state(States.IDLE)
	speed_shooting = speed * speed_multiplier
	gun_timer.wait_time = shooting_rate
	speed_using = speed
	
	if owner != null:
		if owner.get_node("BulletsContainer") != null:
			bullet_container = owner.get_node("BulletsContainer")
		else:
			bullet_container = owner
	else:
		bullet_container = self


func _physics_process(delta) -> void:
	movement = speed_using * get_direction().normalized()
	
	move_and_slide(movement, Vector2.ZERO)


func _process(delta) -> void:
	shoot_input()


func get_direction() -> Vector2:
	var direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if not state in [States.SHOOTING, States.DEAD, States.RESPAWNING]:
		if direction.length() > 0:
			change_state(States.MOVING)
		else:
			change_state(States.IDLE)
	
	return direction


func shoot_input() -> void:
	if Input.is_action_pressed("ui_shoot"):
		change_state(States.SHOOTING)
		if can_shoot:
			shoot()
			gun_timer.start()
			can_shoot = false

	if Input.is_action_just_released("ui_shoot"):
		change_state(States.IDLE)


func shoot() -> void:
	for i in range(2):
		var new_bullet := bullet.instance()
		new_bullet.create(shoot_positions.get_child(i).global_position, 0.0)
		bullet_container.add_child(new_bullet)


func _on_GunTimer_timeout() -> void:
	can_shoot = true


func change_state(new_state) -> void:
	match new_state:
		States.IDLE:
			speed_using = speed
			state_text = "IDLE"
		States.MOVING:
			speed_using = speed
			state_text = "MOVING"
		States.RESPAWNING:
			speed_using = speed_respawning
			state_text = "RESPAWNING"
		States.SHOOTING:
			speed_using = speed_shooting
			state_text = "SHOOTING"
		States.GOD:
			state_text = "GOD"
		States.DEAD:
			speed_using = speed_respawning
			state_text = "DEAD"
	state = new_state
