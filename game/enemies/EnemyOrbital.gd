class_name EnemyOrbital
extends EnemyBase

export var angle := 0.0
export var distance := 150

var leader: EnemyBase
var rot_center := Vector2.ZERO


func create(speed_e: float, angle_to_l:float, distance_to_l: int) -> void:
	leader = get_parent()
	self.speed = speed_e
	angle = angle_to_l
	distance = distance_to_l

func _ready() -> void:
	if leader == null:
		leader = get_parent()

func _process(delta: float) -> void:
	if leader != null:
		global_position = leader.global_position + Vector2(cos(angle), sin(angle)) * distance
		angle += speed * delta

func die() -> void:
	$DamageCollider.set_deferred("disabled", true)
	if leader != null:
		leader.remove_orbital(self)
	animation_player.play("destroy")
	is_alive = false
	can_take_damage = false

func die_on_leader_death() -> void:
	play_explosion_sfx()
	is_alive = false
	can_take_damage = false
	self.sprite.visible = false
	self.motor.visible = false
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()
