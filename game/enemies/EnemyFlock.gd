class_name EnemyFlock
extends Area2D

export var angle := 0.0
export(float, 0.5, 3.5) var speed := 1.5
export var distance := 150

var leader: EnemyBase
var rot_center := Vector2.ZERO

onready var body := $Sprite


func _ready() -> void:
	leader = get_parent()


func _process(delta: float) -> void:
	if leader != null:
		global_position = leader.global_position + Vector2(cos(angle), sin(angle)) * distance
		angle += speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		play_explosion()

func play_explosion() -> void:
	$AnimationPlayer.play("die")
	$Explosion/ExplosionPlayer.play("explosion")
