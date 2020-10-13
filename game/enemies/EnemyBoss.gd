class_name EnemyBoss
extends EnemyBase

#### Variables Export
export var bullet: PackedScene
export var bullet_speed := 400
export var test_shoot := false

#### Variables
var bullet_rot_correction := 0.0
var is_shooting := false
var is_boss := true setget ,get_is_boss
var original_speed := 0.0
var can_shoot := true setget set_can_shoot, get_can_shoot

#### Variables Onready
#onready var shoot_sound := $ShootSFX


#### Setters y Getters
func set_can_shoot(value: bool) -> void:
	can_shoot = value

func get_can_shoot() -> bool:
	return can_shoot

func get_is_boss() -> bool:
	return is_boss

func get_bullet() -> PackedScene:
		return bullet


#### Metodos
func _ready() -> void:
	original_speed = self.speed
	#ToDo: borrar esto en el build definitivo
	if test_shoot:
		can_shoot = true

func _process(_delta: float) -> void:
	if can_shoot and self.allow_shoot:
		shoot()

func shoot() -> void:
	pass


func disabled_collider() -> void:
	.disabled_collider()
	self.can_shoot = false
