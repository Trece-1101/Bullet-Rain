class_name EnemyShooter
extends EnemyBase

#### Variables Export
export var bullet: PackedScene
export var bullet_speed := 400
export var can_shoot := false

#### Variables
var bullet_rot_correction := 0.0
var is_shooting := false
var shoot_lines := {"shoot_on": false, "shoot_off": false, "mid_stop": false}
var bullet_container: Node
var original_speed := 0.0
var mid_point := 0.5

#### Variables Onready
onready var shoot_sound := $ShootSFX
onready var shoot_positions := $ShootPositions
onready var gun_timer := $GunTimer
onready var mid_stoper_timer := $MidStoperTimer

#### Metodos
func _ready() -> void:
	original_speed = self.speed
	bullet_container = .get_top_level().get_node("BulletsContainer")
	mid_point = create_random_mid_point()


func _process(_delta: float) -> void:
	if can_shoot and self.allow_shoot:
		shoot()


func shoot() -> void:
	can_shoot = false
	self.gun_timer.start()
	self.shoot_sound.play()
	for i in range(self.shoot_positions.get_child_count()):
		var new_bullet := bullet.instance()
		new_bullet.create(
				self.shoot_positions.get_child(i).global_position,
				bullet_speed,
				0.0,
				self.shoot_positions.get_child(i).get_bullet_type(),
				1.0,
				self.shoot_positions.get_child(i).get_bullet_angle() + bullet_rot_correction)
		bullet_container.add_child(new_bullet)


func check_shooting_status():
	if self.follow.unit_offset >= 0.15 and not is_shooting and not shoot_lines.shoot_on:
		is_shooting = true
		can_shoot = true
		shoot_lines.shoot_on = true

	if self.follow.unit_offset >= 0.85 and is_shooting and not shoot_lines.shoot_off and path.get_is_timered():
		is_shooting = false
		can_shoot = false
		self.allow_shoot = false
		shoot_lines.shoot_off = true


func check_mid_of_path() -> void:
	if self.follow.unit_offset >= mid_point and is_shooting and path.get_is_timered() and not shoot_lines.mid_stop:
		shoot_lines.mid_stop = true
		self.speed = 0.0
		mid_stoper_timer.start()


func check_end_of_path() -> void:
	if follow.unit_offset >= 1.0:
		if path.get_is_timered():
			queue_free()
		else:
			self.speed = 0.0

func _on_GunTimer_timeout() -> void:
	can_shoot = true


func _on_MidStoperTimer_timeout() -> void:
	self.speed = original_speed

func create_random_mid_point() -> float:
	randomize()
	mid_stoper_timer.wait_time = rand_range(2.5, 3)
	return rand_range(0.45, 0.55)
