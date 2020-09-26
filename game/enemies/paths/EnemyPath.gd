class_name EnemyPath
extends Path2D

#### Señales
signal full_path_dead

#### Variables Export
export(Array, PackedScene) var enemies
export(int, 1, 10) var enemy_number := 1
export(float, 50, 1000) var speed := 200
export var allow_enemy_shoot := true
export(float, 0.2, 10.0) var spawn_enemy_rate := 1.0
export var are_aimers := false
export var debug := false


#### Variables
var enemies_spawned := 0
var full_path_out := false
var spawn_timer: Timer
var is_timered := true
var start_inside_screen := false

#### Setters y Getters
func get_enemy_number() -> int:
	return enemy_number

func get_is_timered() -> bool:
	return is_timered


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
	spawn_enemy()

func _process(_delta: float) -> void:
	var enemies_remaining = $Enemies.get_child_count()
	if full_path_out and enemies_remaining == 0:
		emit_signal("full_path_dead")
		queue_free()

func spawn_enemy() -> void:
	pass

#func spawn_enemy() -> void:
#	if enemies_spawned < enemy_number:
#		create_random_enemy()
#		spawn_timer.start()
#	else:
#		spawn_timer.stop()

func create_random_enemy() -> void:
	var rand_enemy := 0
	if enemies.size() > 1:
		randomize()
		rand_enemy = int(rand_range(0, enemies.size()))
	
	create_enemy(rand_enemy)

func create_enemy(rand_enemy: int) -> void:
	var my_enemy: EnemyBase = enemies[rand_enemy].instance()
	my_enemy.set_speed(speed)
	my_enemy.set_path(self)
	my_enemy.set_allow_shoot(allow_enemy_shoot)
	my_enemy.set_is_aimer(are_aimers)
	my_enemy.set_inside_play_screen(start_inside_screen)
# warning-ignore:return_value_discarded
	my_enemy.connect("enemy_destroyed", self, "_on_Enemy_destroyed", [], CONNECT_DEFERRED)
	$Enemies.add_child(my_enemy)
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

#func _on_Timer_timeout() -> void:
#	if is_timered:
#		spawn_enemy()
#	else:
#		check_enemy_status()

#func _on_Enemy_destroyed():
#	if not is_timered:
#		spawn_enemy()
