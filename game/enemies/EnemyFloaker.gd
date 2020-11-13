class_name EnemyFloaker
extends EnemyBase

export var move_speed := 100.0
export var velocity := Vector2(50.0, 50.0)
export var accel := Vector2(50.0, 50.0)
export var steer_force = 50.0
export var alignment_force = 0.6
export var cohesion_force = 0.6
export var seperation_force = 1.0
export var avoidance_force = 3.0

var floakers = [] setget set_floakers
var perception_radius = 40

onready var detectors = $ObsticleDetectors
onready var sensors = $ObsticleSensors

func set_floakers(value: Array) -> void:
	floakers = value

func _ready() -> void:
	randomize()
	
	velocity = Vector2(rand_range(-1, 1), 1.0).normalized() * move_speed

func _process(delta: float) -> void:
	var neighbors = get_neighbors(perception_radius)
	
	accel += process_alignments(neighbors) * alignment_force
	accel += process_cohesion(neighbors) * cohesion_force
	accel += process_seperation(neighbors) * seperation_force
	
	if is_obsticle_ahead():
		accel += process_obsticle_avoidance() * avoidance_force
	
	
	velocity += accel * delta
	velocity = velocity.clamped(move_speed)
	rotation = velocity.angle() - 1.57
	
	translate(velocity * delta)

func process_alignments(neighbors):
	var vector = Vector2()
	if neighbors.empty():
		return vector
		
	for floaker in neighbors:
		vector += floaker.velocity
	vector /= neighbors.size()
	return steer(vector.normalized() * move_speed)

func process_cohesion(neighbors):
	var vector = Vector2()
	if neighbors.empty():
		return vector
	for floaker in neighbors:
		vector += floaker.position
	vector /= neighbors.size()
	return steer((vector - position).normalized() * move_speed)

func process_seperation(neighbors):
	var vector = Vector2()
	var close_neighbors = []
	for floaker in neighbors:
		if position.distance_to(floaker.position) < perception_radius / 2:
			close_neighbors.push_back(floaker)
	if close_neighbors.empty():
		return vector
	
	for floaker in close_neighbors:
		var difference = position - floaker.position
		vector += difference.normalized() / difference.length()
	
	vector /= close_neighbors.size()
	return steer(vector.normalized() * move_speed)

func process_obsticle_avoidance():
	for ray in sensors.get_children():
		if not ray.is_colliding():
			return steer((ray.cast_to.rotated(ray.rotation + rotation)).normalized() * move_speed)
			
	return Vector2.ZERO

func get_neighbors(view_radius):
	var neighbors = []

	for floaker in floakers:
		if floaker != null:
			if position.distance_to(floaker.position) <= view_radius and not floaker == self:
				neighbors.push_back(floaker)
	return neighbors

func steer(var target):
	var steer = target - velocity
	steer = steer.normalized() * steer_force
	return steer

func is_obsticle_ahead():
	for ray in detectors.get_children():
		if ray.is_colliding() and ray.get_collider() != null:
			if not "Floaker" in ray.get_collider().name:
				return true
	return false

func eliminate() -> void:
	floakers.erase(self)
	for floaker in floakers:
		if floaker != self and floaker != null:
			floaker.set_floakers(floakers)
			
	queue_free()

func die() -> void:
	set_process(false)
	is_alive = false
	can_take_damage = false
	animation_player.play("destroy")
