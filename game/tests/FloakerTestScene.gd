extends Node2D

export var floakers_amount := 5

onready var enemy_floaker := preload("res://game/enemies/EnemyFloaker.tscn")
onready var floaker_container := $FloakerContainer

var floakers := []

func _ready() -> void:
	$Timer.start()
#	if floaker_container.get_child_count() == 0:
#		for i in floakers_amount:
#			var new_floaker: EnemyFloaker = enemy_floaker.instance()
#			floaker_container.add_child(new_floaker)
#			floakers.push_back(new_floaker)
#	else:
#		floakers = floaker_container.get_children()
	
#	for floaker in floaker_container.get_children():
#		floaker.set_floakers(floakers)


func _on_Timer_timeout() -> void:
	floakers_amount -= 1
	if floakers_amount <= 0:
		return
	spawn_floaker()

func spawn_floaker() -> void:
	for pos in $FloakerSpawner.get_children():
		var new_floaker: EnemyFloaker = enemy_floaker.instance()
		new_floaker.is_debugging = true
		new_floaker.global_position = pos.global_position
		floaker_container.add_child(new_floaker)
		floakers.push_back(new_floaker)
	
	for floaker in floaker_container.get_children():
		floaker.set_floakers(floakers)
