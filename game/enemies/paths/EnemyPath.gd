class_name EnemyPath
extends Path2D

#### Señales
signal destroyed()

#### Variables Export
export(Array, PackedScene) var enemies
export(int, 1, 10) var enemy_number := 1
export(float, 50, 1000) var speed := 200
export var is_timered := true
export var debug := false


#### Variables
var enemies_spawned := 0


#### Varibales Onready
onready var spawn_timer := $Timer


#### Setters y Getters
func get_enemy_number() -> int:
	return enemy_number

#### Metodos
func _ready() -> void:
	spawn_enemy()


func spawn_enemy() -> void:
	if enemies_spawned < enemy_number:
		create_random_enemy()
		spawn_timer.start()
	else:
		spawn_timer.stop()

func create_random_enemy() -> void:
	var rand_enemy := 0
	if enemies.size() > 1:
		randomize()
		rand_enemy = int(rand_range(0, enemies.size()))
	
	var my_enemy: EnemyBase = enemies[rand_enemy].instance()
	my_enemy.set_speed(speed)
	my_enemy.set_path(self)
	add_child(my_enemy)
	enemies_spawned += 1
	if debug:
		print("spawneando desde {path} - enemies_spawned {es} - enemy_number {en}".format({"path": self.name, "es": enemies_spawned, "en": enemy_number}))


func check_enemy_status() -> void:
	pass


func _on_Timer_timeout() -> void:
	if is_timered:
		spawn_enemy()
	else:
		check_enemy_status()

func _on_enemy_destroyed() -> void:
	emit_signal("destroyed")
