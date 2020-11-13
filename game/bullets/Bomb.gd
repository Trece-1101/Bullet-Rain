class_name Bomb, "res://assets/bullets/enemy_bullet.png"
extends Area2D

#### Constantes
#const bullet := preload("res://game/bullets/BulletEnemy.tscn")
var bullet: PackedScene

#### Variables export
export(Color, RGBA) var bomb_color := Color.purple
export var freq := 6.0
export var amplitude = 250.0
export var velocity := Vector2(80.0, 150.0)
export var velocity_decay := 0.6
export var explode_umbral := 20.0

#### Variables
var time := 0.0
var bullet_container: Node
var angle := 0.0

#### Metodos
func _ready() -> void:
	add_to_group("bomb")
	bullet = load("res://game/bullets/BulletEnemy.tscn")
	randomize()
	var rand := int(rand_range(0, 2))
	if rand >= 1:
		amplitude *= -1
	set_color($Sprite, 1.4, 0.8, 2.0)
	bullet_container = get_tree().get_nodes_in_group("bullets_container")[0]

func _process(delta: float) -> void:
	time += delta
	velocity.x = cos(time * freq) * amplitude
	velocity -= Vector2(velocity_decay, velocity_decay)
	if velocity.y <= explode_umbral:
		explote()
	
	position += velocity * delta

func destroy() -> void:
	$AnimationPlayer.play("destroy")

func set_color(node: Node2D, red: float, green: float, blue: float) -> void:
	node.modulate.r = red
	node.modulate.g = green
	node.modulate.b = blue

func explote() -> void:
	for _i in range(24):
		var new_bullet := bullet.instance()
		new_bullet.create(
			self,
			global_position,
			300.0,
			0,
			0,
			1,
			angle
		)
		new_bullet.add_to_group("bullet_enemy")
		bullet_container.add_child(new_bullet)
		angle += 15.0
	
	queue_free()



func _on_area_entered(area: Area2D) -> void:
	area.destroy()

func _on_body_entered(body: Node) -> void:
	body.take_damage()
