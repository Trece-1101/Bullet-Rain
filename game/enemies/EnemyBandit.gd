class_name EnemyBandit
extends EnemyShooter

#### Variables
var aim_error := 0.0
var is_leader := false
var orbitals := [] setget ,get_orbitals
export var orbital_enemy: PackedScene

#### Setters y Getters
func get_orbitals() -> Array:
	return orbitals


#### Metodos
func _ready() -> void:
	for child in get_children():
		if child is EnemyOrbital:
			orbitals.append(child)
	
	if is_aimer and not player == null:
		randomize()
		aim_error = rand_range(-10.0, 10.0)


func create_orbital() -> void:
	if orbital_enemy != null:
		var minion := orbital_enemy.instance()
		minion.create(self, 1.5, 45, 200)
		add_child(minion)
		orbitals.append(minion)


func _on_AimTimer_timeout() -> void:
	if not player == null:
		check_aim_to_player()

func _process(_delta: float):
	if is_aimer and not player == null:
		check_aim_to_player()

func check_aim_to_player() -> void:
	var dir = player.global_position - global_position
	var rot = dir.angle()
	var rot_look = rot - 1.57
	var my_rotation = rad2deg(rot_look) + aim_error
	bullet_rot_correction = rad2deg(rot) - 90.0 + aim_error
	rotation_degrees = my_rotation

func remove_orbital(orbital: EnemyOrbital) -> void:
	orbitals.erase(orbital)

func die() -> void:
	.die()
	if orbitals.size() > 0:
		yield(get_tree().create_timer(0.6), "timeout")
		for orbital in orbitals:
			if orbital != null:
				orbital.die_on_leader_death()
