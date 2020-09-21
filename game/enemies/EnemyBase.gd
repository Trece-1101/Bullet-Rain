extends Area2D
class_name EnemyBase

#### Variables Export
export var hitpoints := 50
export var bullet: PackedScene
export(int, -1, 1) var bullet_type := 1
export var bullet_speed := 400
export var bullet_angle := 0

#### Variables
var can_shoot := true


#### Variables Onready
onready var shoot_sound := $ShootSFX
onready var shoot_positions := $ShootPositions
onready var bullet_container: Node


#### Setters y Getters



#### Metodos
func _ready() -> void:
	if bullet_type == 0:
		bullet_type = 1
	
	if owner != null:
		if owner.get_node("BulletsContainer") != null:
			bullet_container = owner.get_node("BulletsContainer")
		else:
			bullet_container = owner
	else:
		bullet_container = self

func _process(delta):
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
				bullet_type,
				1.0,
				bullet_angle)
		bullet_container.add_child(new_bullet)
		#bullet_angle *= -1
		#bullet_type *= -1



func _on_GunTimer_timeout():
	can_shoot = true


func _on_area_entered(area):
	check_hitpoints(area.get_damage())

func check_hitpoints(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()
