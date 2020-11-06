class_name EnemyPather
extends EnemyBase

#### Señales
signal enemy_destroyed()

#### Constantes
const scrap: PackedScene = preload("res://game/scrap/Scrap.tscn")

#### Variables exports
export var is_aimer := false setget set_is_aimer
export var scrap_chance := 0.0

#### Variables
var end_of_path := 1.0 setget set_end_of_path, get_end_of_path
var is_stopper := false setget set_is_stopper
var path: Path2D setget set_path
var follow: PathFollow2D

#### Setters y Getters
func set_path(value: Path2D) -> void:
	path = value

func set_is_aimer(value: bool) -> void:
	is_aimer = value

func set_end_of_path(value: float) -> void:
	end_of_path = value

func get_end_of_path() -> float:
	return end_of_path

func set_is_stopper(value: bool) -> void:
	is_stopper = value


#### Metodos
func _ready() -> void:
	if path != null:
		follow = PathFollow2D.new()
		path.add_child(follow)
		follow.loop = false

	if is_aimer:
		get_player()

func _process(delta: float) -> void:
	if path != null and is_alive:
		move(delta)

func move(delta: float) -> void:
	follow.offset += speed * delta
	position = follow.global_position

	if is_stopper:
		 check_mid_of_path()
	
	check_end_of_path()

func check_end_of_path() -> void:
	if follow.unit_offset >= self.end_of_path:
		var action:String = path.at_end_of_path()
		if action == "free":
			queue_free()
		elif action == "stop":
			speed = 0.0
		elif action == "stop and shoot":
			speed = 0.0
			self.allow_shoot = true


func check_mid_of_path() -> void:
	pass

func die() -> void:
	is_alive = false
	can_take_damage = false
	emit_signal("enemy_destroyed")
	animation_player.play("destroy")
	if scrap_chance != 0.0:
		_scrap_roulette()

func _scrap_roulette() -> void:
	randomize()
	var rand := randf()
	if rand <= scrap_chance:
		call_deferred("_add_scrap")

func _add_scrap() -> void:
	var new_scrap:Scrap = scrap.instance()
	new_scrap.create(global_position, int(scrap_reward * 2.0))
	get_top_level().add_child(new_scrap)
