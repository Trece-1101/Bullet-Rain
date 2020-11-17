class_name Ultimate
extends Node

var ultimate_duration := 4.0
var ult_timer: Timer
var parent: KinematicBody2D
var shoot_sfx: AudioStreamPlayer

onready var animation: PackedScene

func _ready() -> void:
	parent = get_parent()
	ult_timer = Timer.new()
	ult_timer.wait_time = ultimate_duration
	ult_timer.one_shot = true
	ult_timer.connect("timeout", self, "end_ultimate")
	add_child(ult_timer)

func create_sfx(stream_path: String, volume: float) -> void:
	shoot_sfx = AudioStreamPlayer.new()
	var stream := stream_path
	shoot_sfx.stream = load(stream)
	shoot_sfx.bus = "Player"
	shoot_sfx.volume_db = volume
	shoot_sfx.pitch_scale = 1
	shoot_sfx.name = "UltSFX"
	add_child(shoot_sfx)

func use_ultimate() -> void:
	pass

func end_ultimate() -> void:
	pass
