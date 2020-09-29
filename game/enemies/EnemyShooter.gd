class_name EnemyShooter
extends EnemyBase

#### Variables Export
export var bullet: PackedScene
export var bullet_speed := 400
export var test_shoot := false

#### Variables
var bullet_rot_correction := 0.0
var is_shooting := false
var shoot_lines := {"mid_stop": false}
var bullet_container: Node
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


#### Metodos
func _ready() -> void:
	#ToDo: borrar esto en el build definitivo
	if test_shoot:
		can_shoot = true
		inside_play_screen = true
	
	original_speed = self.speed
	bullet_container = .get_top_level().get_node("BulletsContainer")
	mid_point = create_random_mid_point()


func _process(_delta: float) -> void:
	if can_shoot and self.allow_shoot and self.inside_play_screen:
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


func check_mid_of_path() -> void:
	if self.follow.unit_offset >= mid_point and path.get_is_timered() and not shoot_lines.mid_stop:
		shoot_lines.mid_stop = true
		self.speed = 0.0
		mid_stoper_timer.start()


func _on_GunTimer_timeout() -> void:
	can_shoot = true

func _on_MidStoperTimer_timeout() -> void:
	self.speed = original_speed * 1.0

func create_random_mid_point() -> float:
	randomize()
	mid_stoper_timer.wait_time = rand_range(2.5, 3)
	return rand_range(0.45, 0.55)

func disabled_collider() -> void:
	.disabled_collider()
	self.can_shoot = false
	gun_timer.stop()
