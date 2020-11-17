class_name UltimateBomber
extends Ultimate

#### Variables Export
onready var missile := load("res://game/bullets/Missile.tscn")
var missile_damage := 5.0
#var gun_timer: Timer
var bullet_container: Node
onready var gun_timer := $GunTimer


func _ready() -> void:
#	._ready()
#	gun_timer = Timer.new()
#	gun_timer.wait_time = 0.20
#	gun_timer.one_shot = false
#	gun_timer.name = "GunTimer"
#	gun_timer.connect("timeout", self, "shoot_missile")
#	add_child(gun_timer)
	bullet_container = get_tree().get_nodes_in_group("bullets_container")[0]
#	create_sfx(
#		"res://assets/sounds/sfx/player/ultimates/bomber/ultimatebomber03.wav",
#		-15)


func use_ultimate() -> void:
	if get_parent() != null and get_parent().get_is_alive():
		ult_timer.start()
		gun_timer.start()


func shoot_missile() -> void:
	if parent != null and parent.get_is_alive():
		get_node("UltSFX").play()
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

func end_ultimate() -> void:
	gun_timer.stop()

func _on_GunTimer_timeout() -> void:
	shoot_missile()
