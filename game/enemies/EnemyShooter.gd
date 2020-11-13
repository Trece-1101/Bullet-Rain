class_name EnemyShooter
extends EnemyPather

#### Variables Export
#export var is_boss := false setget ,get_is_boss
export var bullet: PackedScene
export var bullet_speed := 400
export var shooting_rate := 1.0
export var test_shoot := false
export(Array, NodePath) var indestructible_bullets

#### Variables
var bullet_rot_correction := 0.0
var is_shooting := false
var shoot_lines := {"mid_stop": false}
#var bullet_container: Node
var original_speed := 0.0
var mid_point := 0.5
var can_shoot := true setget set_can_shoot, get_can_shoot


#### Variables Onready
onready var shoot_sound := $ShootSFX
onready var shoot_positions := $ShootPositions
onready var gun_timer := $GunTimer
onready var mid_stoper_timer := $MidStoperTimer

#### Setters y Getters
func set_can_shoot(value: bool) -> void:
	can_shoot = value

func get_can_shoot() -> bool:
	return can_shoot


func get_bullet() -> PackedScene:
	return bullet

#### Metodos
func _ready() -> void:
	add_to_group("enemy_shooter")
	if test_shoot and OS.is_debug_build():
		can_shoot = true
		inside_play_screen = true
	
	if indestructible_bullets.size() > 0:
		set_indestructible_bullet()
	
	original_speed = self.speed
	gun_timer.wait_time = shooting_rate
	mid_point = create_random_mid_point()


func _process(_delta: float) -> void:
	if can_shoot and self.allow_shoot and self.inside_play_screen:
		shoot()


func shoot() -> void:
	can_shoot = false
	self.gun_timer.start()
	self.shoot_sound.play()
	for shoot_position in shoot_positions.get_children():
		shoot_position.shoot_bullet(
			bullet_speed,
			0.0,
			shoot_position.get_bullet_type(),
			1.0,
			bullet_rot_correction
		)


func check_mid_of_path() -> void:
	if self.is_stopper:
		if self.follow.unit_offset >= mid_point and not shoot_lines.mid_stop:
			shoot_lines.mid_stop = true
			self.speed = 0.0
			mid_stoper_timer.start()


func _on_GunTimer_timeout() -> void:
	can_shoot = true


func _on_MidStoperTimer_timeout() -> void:
	self.speed = original_speed * 0.6


func set_indestructible_bullet() -> void:
	for path in indestructible_bullets:
		get_node(path).set_bullet_type(0)


func create_random_mid_point() -> float:
	randomize()
	mid_stoper_timer.wait_time = rand_range(2, 2.5)
	return rand_range(0.48, 0.52)

func disabled_collider() -> void:
	.disabled_collider()
	self.can_shoot = false
	gun_timer.stop()

func disabled_shooting() -> void:
	if not is_boss:
		can_shoot = false
		allow_shoot = false
		gun_timer.stop()
