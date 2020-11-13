class_name EnemyFreeTeleporter
extends EnemyFree

#### Variables Onready
onready var animation_teletransportation := $AnimationTeletrasportation
onready var teleport_ring := $TeleportRing


#### Metodos
func _ready() -> void:
	teleport_ring.set_as_toplevel(true)

func die() -> void:
	teleport_ring.queue_free()
	.die()

func make_your_move(new_position: Vector2) -> void:
	teleport_ring.global_position = new_position
	$TeleportRing/AnimationPlayer.play("warp")
	yield(get_tree().create_timer(0.4), "timeout")
	global_position = new_position
	animation_teletransportation.play("teleport")
	self.new_position_timer.start()
