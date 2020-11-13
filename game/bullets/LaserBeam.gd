class_name LaserBeam
extends RayCast2D

export var cast_time := 5.0
export var cool_down := 3.0
export var cast_speed := 7000.0
export var max_length := 1400
export var growth_time := 0.1
export(String, "Right", "Left", "Up", "Down") var vector_cast

var is_casting := false setget set_is_casting
var casting_vector = Vector2.RIGHT

onready var fill := $FillLine2D
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D

onready var line_width: float = fill.width


func _ready() -> void:
	match vector_cast:
		"Right":
			casting_vector = Vector2.RIGHT
		"Left":
			casting_vector = Vector2.LEFT
		"Up":
			casting_vector = Vector2.UP
			beam_particles.rotation_degrees = 90
		"Down":
			casting_vector = Vector2.DOWN
			beam_particles.rotation_degrees = 90
		_:
			casting_vector = Vector2.RIGHT
	
	$CastTimer.wait_time = cast_time
	$CoolDownTimer.wait_time = cool_down
	casting_particles.modulate = Color.purple
	beam_particles.modulate = Color.purple
	collision_particles.modulate = Color.purple
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO


func _physics_process(delta: float) -> void:
	cast_to = (cast_to + casting_vector * cast_speed * delta).clamped(max_length)
	cast_beam()


func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		$CastTimer.start()
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		$CoolDownTimer.start()
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting

func get_is_casting() -> bool:
	return is_casting

func toogle_beam(value: int) -> void:
	is_casting = value

	if is_casting:
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting

func cast_beam() -> void:
	var cast_point := cast_to

	force_raycast_update()
	collision_particles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.process_material.direction = Vector3(
			get_collision_normal().x, get_collision_normal().y, 0
		)
		collision_particles.position = cast_point
		
		if get_collider() is Player and get_collider() != null:
			get_collider().die()

	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	


func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()


func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()


func _on_CoolDownTimer_timeout() -> void:
	set_is_casting(true)


func _on_CastTimer_timeout() -> void:
	set_is_casting(false)
