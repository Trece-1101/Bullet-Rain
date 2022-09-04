extends Bullet


func _process(delta: float) -> void:
	position += velocity * delta
	bullet_sprite.rotation += 2 * PI * delta * 0.25
