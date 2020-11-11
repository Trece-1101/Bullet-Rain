extends EnemyBossBT

#### Variables
var time := 0.0
var vertical_speed := 0.0
var original_amplitude := 0.0
var speed_decay := 0.0
var freq := 0.0
var amplitude := 0.0

#### Metodos
func _ready() -> void:
	add_movements()
	add_shoot_positions()
	manage_move_stages(1)

func _physics_process(delta: float) -> void:
	time += delta
	speed = cos(time * freq) * amplitude
	vertical_speed -= speed_decay
	if global_position.y <= 150.0 or global_position.y >= 350.0:
		go_backward()
		
	position += Vector2(speed, vertical_speed) * delta


func add_shoot_positions() -> void:
	add_shoot_positions_to_container(3, $ShootPositions3, bullet_speed * 0.6, shoot_rate * 1.2)
	add_shoot_positions_to_container(4, $ShootPositions4, bullet_speed * 0.9, shoot_rate * 0.9)
	add_shoot_positions_to_container(5, $ShootPositions5, bullet_speed * 0.7, shoot_rate * 0.6)

func add_movements() -> void:
	#5 ultimo antes de morir
	blackboard.movement_type[1] = {
		"speed": 0.0,
		"freq": 1.0,
		"amplitude": 240.0,
		"speed_decay": 0.00
	}
	blackboard.movement_type[2] = {
		"speed": 60,
		"freq": 4.0,
		"amplitude": 300.0,
		"speed_decay": 0.02
	}
	blackboard.movement_type[3] = {
		"speed": 0.0,
		"freq": 2.0,
		"amplitude": 260.0,
		"speed_decay": 0.00
	}
	blackboard.movement_type[4] = {
		"speed": 70,
		"freq": 3.0,
		"amplitude": 280.0,
		"speed_decay": 0.02
	}
	blackboard.movement_type[5] = {
		"speed": 0.0,
		"freq": 1.0,
		"amplitude": 100.0,
		"speed_decay": 0.00
	}

func go_backward() -> void:
	original_speed *= -1
	vertical_speed = original_speed
	speed_decay *= -1

func spawn_minions(critic: bool, type: int) -> void:
	yield(get_tree().create_timer(minions_spawn_delay), "timeout")
	if critic:
		for pos in minions_positions.get_children():
			var new_minion:EnemyBase = critic_minions[type].instance()
			new_minion.global_position = pos.position
			new_minion.set_can_shoot(true)
			new_minion.set_allow_shoot(true)
			new_minion.set_inside_play_screen(true)
			get_parent().add_child(new_minion)
	else:
		for i in range(4):
			var new_minion:EnemyBeamer = normal_minions[i].instance()
			get_parent().add_child(new_minion)

func manage_move_stages(move_stage: int) -> void:
	original_speed = blackboard.movement_type[move_stage].speed
	vertical_speed = original_speed
	original_amplitude = blackboard.movement_type[move_stage].amplitude
	speed_decay = blackboard.movement_type[move_stage].speed_decay
	freq = blackboard.movement_type[move_stage].freq
	amplitude = blackboard.movement_type[move_stage].amplitude
	time = 0.0

