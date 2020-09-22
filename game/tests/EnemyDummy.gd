extends Area2D

export var hitpoints := 50
export var bullet: PackedScene
export var bullet_type := 1
var bullet_speed := 500
onready var shoot_test = $ShootTest
onready var explosion_test = $ExplosionTest

var can_shoot := true

func _process(delta):
	if can_shoot:
		var new_bullet := bullet.instance()
		new_bullet.create(
				global_position,
				bullet_speed,
				0.0,
				bullet_type)
		owner.get_node("BulletsContainer").add_child(new_bullet)
		can_shoot = false
		$GunTimer.start()
		shoot_test.play()


func _on_area_entered(area):
	check_hitpoints(area.get_damage())

func check_hitpoints(damage):
	hitpoints -= damage
	if hitpoints == 0:
		explosion_test.play()
		#queue_free()


func _on_GunTimer_timeout():
	can_shoot = true
