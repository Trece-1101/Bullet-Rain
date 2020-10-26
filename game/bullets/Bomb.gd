class_name Bomb,  "res://assets/bullets/enemy_bullet_temp.png"
extends Area2D

#### Constantes
const bullet := preload("res://game/bullets/BulletEnemy.tscn")

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
	randomize()
	var rand := int(rand_range(0, 2))
	if rand >= 1:
		amplitude *= -1
	$Sprite.modulate = bomb_color
	bullet_container = get_tree().get_nodes_in_group("bullets_container")[0]

func _process(delta: float) -> void:
	time += delta
	velocity.x = cos(time * freq) * amplitude
	velocity -= Vector2(velocity_decay, velocity_decay)
	if velocity.y <= explode_umbral:
		explote()
	
	position += velocity * delta

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
		bullet_container.add_child(new_bullet)
		angle += 15.0
	
	queue_free()




func _on_area_entered(area: Area2D) -> void:
	area.destroy()

func _on_body_entered(body: Node) -> void:
	body.take_damage()
