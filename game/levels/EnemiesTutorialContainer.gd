extends Node

export(Array, PackedScene) var dummies := []
export(Array, PackedScene) var i_bullers := []
export(Array, PackedScene) var aimers := []
export(PackedScene) var scrapper
export(PackedScene) var rotator


func _ready() -> void:
	Events.connect("send_dummy_enemies", self, "_on_send_dummy_enemies")
	Events.connect("send_i_bullers_enemies", self, "_on_send_i_bullers")
	Events.connect("send_rotator_enemy", self, "_on_send_rotator_enemy")
	Events.connect("send_aimers_enemies", self, "_on_send_aimers_enemies")


func _on_send_dummy_enemies(full_scrap: bool) -> void:
	if full_scrap:
		send_scrapper()
		return
	
	send_common_enemies()
	

func send_common_enemies() -> void:
	var offset := 0
	for i in range(3):
		var new_enemy:EnemyBandit = dummies[choose_random_dummy(dummies.size())].instance()
		new_enemy.can_shoot = true
		new_enemy.is_aimer = false
		new_enemy.test_shoot = true
		new_enemy.scrap_chance = 0.0
		new_enemy.position.y = 180.0
		new_enemy.position.x = 760.0 + offset
		add_child(new_enemy)
		offset += 200.0


func _on_send_i_bullers() -> void:
	var offset := 0
	for i in range(2):
		var new_enemy:EnemyBandit = i_bullers[choose_random_dummy(i_bullers.size())].instance()
		new_enemy.can_shoot = true
		new_enemy.is_aimer = false
		new_enemy.test_shoot = true
		new_enemy.scrap_chance = 0.0
		new_enemy.position.y = 180.0
		new_enemy.position.x = 760.0 + offset
		add_child(new_enemy)
		offset += 400.0


func _on_send_aimers_enemies() -> void:
	var offset := 0
	for i in range(2):
		var new_enemy:EnemyBandit = aimers[choose_random_dummy(aimers.size())].instance()
		new_enemy.can_shoot = true
		new_enemy.is_aimer = true
		new_enemy.test_shoot = true
		new_enemy.scrap_chance = 0.0
		new_enemy.position.y = 180.0
		new_enemy.position.x = 760.0 + offset
		add_child(new_enemy)
		offset += 400.0

func _on_send_rotator_enemy() -> void:
	var new_enemy:EnemyRotator = rotator.instance()
	new_enemy.scrap_chance = 0.0
	new_enemy.position.y = 180.0
	new_enemy.position.x = 960.0
	new_enemy.can_shoot = true
	new_enemy.test_shoot = true
	add_child(new_enemy)


func send_scrapper() -> void:
	var new_enemy:EnemyBandit = scrapper.instance()
	new_enemy.is_aimer = false
	new_enemy.scrap_chance = 100.0
	new_enemy.position.y = 180.0
	new_enemy.position.x = 960.0
	add_child(new_enemy)


func choose_random_dummy(array_size: int) -> int:
	randomize()
	var random_index := randi() % array_size
	return random_index
