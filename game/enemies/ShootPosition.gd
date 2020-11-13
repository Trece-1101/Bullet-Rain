class_name ShootPosition
extends Position2D

#### Variables Export
export var bullet_angle := 0.0 setget set_bullet_angle
export var bullet_quantity := 1
export var angle_separation := 0.0 setget set_angle_separation

#### Variables
var bullet_container: Node
var parent: Object
var bullet: PackedScene


#### Variables Onready
onready var bullet_type := -1

#### Setters y Getters
func get_bullet_angle () -> float:
	return bullet_angle

func set_bullet_type(value: int) -> void:
	bullet_type = value

func get_bullet_type() -> int:
	return bullet_type

func set_bullet_angle(value: float) -> void:
	bullet_angle = value

func set_angle_separation(value: float) -> void:
	angle_separation = value


#### Metodos
func _ready() -> void:
	add_to_group("shoot_position")
	if owner != null:
		parent = owner
		bullet = parent.get_bullet()

	bullet_container = get_tree().get_nodes_in_group("bullets_container")[0]


func shoot_bullet(speed: float, dir: float, type: int, damage: float, angle_correction := 0.0, debug := false) -> void:
	var cone_range := angle_separation * 0.5
	var separation := 0.0
	var defase_pos := bullet_quantity - 1
	if defase_pos > 0:
		separation = angle_separation / defase_pos
	
	for i in range(bullet_quantity):
		var new_bullet:Bullet = bullet.instance()
		new_bullet.create(
			parent,
			global_position,
			speed,
			dir,
			type,
			damage,
			bullet_angle + angle_correction + (cone_range - separation * i)
		)
		bullet_container.add_child(new_bullet)
	
	if debug and OS.is_debug_build():
		print(
			"Creador: {c} - Vel: {s} - Daño: {d}".format({
				"c": owner, "s": speed, "d": damage
			})
		)

func change_angle(value: float) -> void:
	bullet_angle += value

func change_separation(value: float) -> void:
	angle_separation += value
