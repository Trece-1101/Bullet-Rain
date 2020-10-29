class_name UltimateBomber
extends Ultimate

var missile := load("res://game/bullets/Missile.tscn")
var missile_damage := 5.0
var gun_timer: Timer
var bullet_container: Node

var total_damage := 0.0


func _ready() -> void:
	._ready()
	gun_timer = Timer.new()
	gun_timer.wait_time = 0.20
	gun_timer.one_shot = false
	gun_timer.name = "GunTimer"
	gun_timer.connect("timeout", self, "shoot_missile")
	add_child(gun_timer)
	bullet_container = get_tree().get_nodes_in_group("bullets_container")[0]


func use_ultimate() -> void:
	ult_timer.start()
	gun_timer.start()


func shoot_missile() -> void:
	for pos in parent.get_node("MissilesPositions").get_children():
		var new_missile = missile.instance()
		new_missile.create(
			parent,
			pos.global_position,
			-1000.0,
			0.0,
			0,
			missile_damage
		)
		bullet_container.add_child(new_missile)
		#TODO: quitar esto
		total_damage += missile_damage

func end_ultimate() -> void:
	gun_timer.stop()
	print(total_damage)
