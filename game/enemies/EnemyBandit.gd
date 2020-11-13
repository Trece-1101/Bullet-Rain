class_name EnemyBandit
extends EnemyShooter

#### Variables export
export var has_orbitals := false
export var orbital_enemy: PackedScene


#### Variables
var aim_error := 0.0
var is_leader := false
var aim := true
var orbitals := [] setget ,get_orbitals

#### Setters y Getters
func get_orbitals() -> Array:
	return orbitals

#### Metodos
func _ready() -> void:
	if has_orbitals:
		add_orbitals()

	
	if is_aimer and player != null:
		randomize()
		aim_error = rand_range(-10.0, 10.0)

func add_orbitals() -> void:
	for child in get_children():
		if child is EnemyOrbital:
			orbitals.append(child)

func create_orbital(speed := 1.5, angle := 45, distance := 200) -> void:
	if orbital_enemy != null:
		var new_orbital := orbital_enemy.instance()
		new_orbital.create(speed, angle, distance)
		add_child(new_orbital)
		orbitals.append(new_orbital)


func _process(_delta: float):
	if is_aimer and aim and player != null and is_alive:
		check_aim_to_player()

func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look) + aim_error
	bullet_rot_correction = rad2deg(rot) - 90.0 + aim_error
	rotation_degrees = my_rotation

func check_aim_to_center() -> float:
	var dir = Vector2(960.0, 920.0) - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look) + aim_error
	bullet_rot_correction = rad2deg(rot) - 90.0 + aim_error
	rotation_degrees = my_rotation
	return my_rotation

func wait(time_to_wait: float) -> void:
	player = null
	allow_shoot = false
	if is_aimer:
		aim = false
		$Tween.interpolate_property(
			self,
			"rotation_degrees",
			rotation_degrees,
			check_aim_to_center(),
			time_to_wait * 0.9,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	aim = true
	allow_shoot = true

func remove_orbital(orbital: EnemyOrbital) -> void:
	orbitals.erase(orbital)

func die() -> void:
	.die()
	if orbitals.size() > 0:
		yield(get_tree().create_timer(0.6), "timeout")
		for orbital in orbitals:
			if orbital != null:
				orbital.die_on_leader_death()


