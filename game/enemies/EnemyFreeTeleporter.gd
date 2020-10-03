class_name EnemyFreeTeleporter
extends EnemyFree

onready var animation_teleport := $AnimationTeleport
onready var animation_teletransportation := $AnimationTeletrasportation
onready var sprite_teleport_ring := $SpriteTeleportRing

func _ready() -> void:
	sprite_teleport_ring.set_as_toplevel(true)

func die() -> void:
	animation_teleport.play("init")
	.die()

func make_your_move(new_position: Vector2) -> void:
	sprite_teleport_ring.global_position = new_position
	animation_teleport.play("spawn_ring")
	yield(get_tree().create_timer(0.4), "timeout")
	global_position = new_position
	animation_teletransportation.play("teleport")
	self.new_position_timer.start()
