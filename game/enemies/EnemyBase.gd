class_name EnemyBase
extends Area2D

#### Variables Export
export var hitpoints := 50.0
export var bullet: PackedScene
export var bullet_speed := 400
export var is_rotator := false

#### Variables
var can_shoot := true
var player: Player
var rotation_correction := 0.0

#### Variables Onready
onready var shoot_sound := $ShootSFX
onready var shoot_positions := $ShootPositions
onready var bullet_container: Node


#### Setters y Getters



#### Metodos
func _ready() -> void:
	#ToDo: Todo esto voy a tener que cambiarlo cuando haga lo de los paths y waves
	if owner != null:
		if is_rotator:
			for child in owner.get_children():
				if child is Player:
					player = child
					set_process(true)
					break
		if owner.get_node("BulletsContainer") != null:
			bullet_container = owner.get_node("BulletsContainer")
		else:
			bullet_container = owner
	else:
		bullet_container = self

func _process(_delta):
	#ToDo: Mejorar este codigo
	if is_rotator:
		var dir = player.global_position - global_position
		var rot = dir.angle()
		var rot_look = rot - 1.57
		rotation_correction = rad2deg(rot) - 90.0
		rotation = rot_look
	
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		shoot()

func shoot() -> void:
	shoot_sound.play()
	for i in range(shoot_positions.get_child_count()):
		var new_bullet := bullet.instance()
		new_bullet.create(
				shoot_positions.get_child(i).global_position,
				bullet_speed,
				0.0,
				shoot_positions.get_child(i).get_bullet_type(),
				1.0,
				shoot_positions.get_child(i).get_bullet_angle() + rotation_correction)
		bullet_container.add_child(new_bullet)



func _on_GunTimer_timeout():
	can_shoot = true


func _on_area_entered(area):
	check_hitpoints(area.get_damage())

func check_hitpoints(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()
