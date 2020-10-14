tool
class_name EnemyPath, "res://assets/enemies/extras/path_img.png"
extends Path2D

#### Señales
signal full_path_dead

#### Variables Export
export(Array, PackedScene) var enemies := []
export(int, 1, 20) var enemy_number := 1
export(float, 50, 1000) var speed := 200
export var allow_enemy_shoot := true
export(float, 0.2, 10.0) var spawn_enemy_rate := 1.0
export var are_aimers := false
export var is_stopper := false
export(int, FLAGS, "LU", "LD", "RU", "RD") var cuadrant := 0
export var make_invisible := false setget set_make_invisible
export var debug := false



#### Variables
var enemies_spawned := 0
var full_path_out := false
var spawn_timer: Timer
var is_timered := true
var start_inside_screen := false
var end_of_path := 1.0
var enemy_container_node: Node

#### Setters y Getters
func get_enemy_number() -> int:
	return enemy_number

func get_is_timered() -> bool:
	return is_timered

func set_make_invisible(value: bool) -> void:
	if value:
		if Engine.editor_hint:
			visible = false

#### Metodos
func _ready() -> void:
	#create_timer()
	set_process(false)


func create_timer() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_enemy_rate
	spawn_timer.set_one_shot(true)
# warning-ignore:return_value_discarded
	spawn_timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(spawn_timer)


func create_path() -> void:
	var enemy_container = Node.new()
	add_child(enemy_container)
	enemy_container.name = "Enemies"
	enemy_container_node = enemy_container
	spawn_enemy()


func _process(_delta: float) -> void:
	var enemies_remaining = enemy_container_node.get_child_count()
	if full_path_out and enemies_remaining == 0:
		emit_signal("full_path_dead")
		queue_free()


func spawn_enemy() -> void:
	pass


func create_random_enemy() -> void:
	var rand_enemy := 0
	if enemies.size() > 1:
		randomize()
		rand_enemy = int(rand_range(0, enemies.size()))
	
	create_enemy(rand_enemy)

func create_enemy(rand_enemy: int) -> void:
	var my_enemy: EnemyPather = enemies[rand_enemy].instance()
	my_enemy.set_speed(speed)
	my_enemy.set_path(self)
	my_enemy.set_allow_shoot(allow_enemy_shoot)
	my_enemy.set_inside_play_screen(start_inside_screen)
	my_enemy.set_end_of_path(end_of_path)
	if my_enemy is EnemyKamikaze:
		my_enemy.set_is_aimer(true)
		my_enemy.set_is_stopper(false)
	elif my_enemy is EnemyFree:
		my_enemy.set_is_aimer(true)
		my_enemy.set_is_stopper(false)
		my_enemy.set_cuadrant(cuadrant)
	elif my_enemy is EnemyRotator:
		my_enemy.set_is_aimer(false)
		my_enemy.set_is_stopper(false)
	else:
		my_enemy.set_is_aimer(are_aimers)
		my_enemy.set_is_stopper(is_stopper)
	check_new_end_of_path()
# warning-ignore:return_value_discarded
	my_enemy.connect("enemy_destroyed", self, "_on_Enemy_destroyed", [], CONNECT_DEFERRED)
	enemy_container_node.add_child(my_enemy)
	enemies_spawned += 1
	check_enemy_status()
	if debug:
		print("spawneando desde {path} - enemies_spawned {es} - enemy_number {en}".format({"path": self.name, "es": enemies_spawned, "en": enemy_number}))

func check_enemy_status() -> void:
	if enemies_spawned == enemy_number:
		set_process(true)
		full_path_out = true

func at_end_of_path() -> String:
	return ""

func _on_Enemy_destroyed() -> void:
	pass

func check_new_end_of_path() -> void:
	pass

func _notification(notification: int) -> void:
	if notification == NOTIFICATION_PARENTED or notification == NOTIFICATION_UNPARENTED:
		update_configuration_warning()

func _get_configuration_warning() -> String:
	if enemies.size() == 0:
		return "No hay naves asignadas al path"
	
	if check_other_errors().value:
		return check_other_errors().error
	
	return ""

func check_other_errors() -> Dictionary:
	return {"value": false, "error": ""}

