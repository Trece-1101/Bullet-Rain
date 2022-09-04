extends CanvasLayer

onready var tutorials := [
	"Welcome to the tutorial\nWait a second... your ship is spawning with his fantastic cover shield mode ON",
	"Movement\nYour ship moves faster when is not shooting. Move with AD or Left Stick. Shoot with left clic or Right Trigger and feel the (tiny) difference\nAlso, when you move foward your bullets are a little bit faster.",
	"Shooting\nYou have 2 types of bullets.\nPrimary (Red): Faster and makes more damage, but can't destroy yellow enemies bullets\nSecondary (Yellow): Slower and makes less damage, but can destroy any (Yellow) enemy bullet\nChange your bullet type with Right Clic or Left Trigger. You don't need to stop shooting for this. Try!",
	"Drone\nYour 'Drone bar' replenish with time and killing enemies. When is full you can call, with CTRL or West Button Gamepad, 2 drones that shoots and provide shield. Try!",
	"Ultimate\nYour 'Ultimate bar' replenish with time and killing enemies. When is full you can call with Space or South Button Gamepad the true power of your ship. Try!",
	"Enemies Bullets\nEnemies can shoot 2 types of bullets\nYellow: this bullet can be destroy with your yellow bullet.\nPurple: this bullet can only be destroy with ultimate powers",
	"Scrap\nAll enemies can provide scrap, the harder the enemy better the chance. You have to chase the scrap before is gone. Only with scrap you can buy upgrades for your ships",
	"Enemies\nThere are all kinds of enemies. Try to understand their behavior when the game is still easy. Then you won't have the chance to look at them. On Bullet Rain... bullets are priority",
	"Enemies\nThere are all kinds of enemies. Try to understand their behavior when the game is still easy. Then you won't have the chance to look at them. On Bullet Rain... bullets are priority",
	"That's about it\nBullet Rain is about a lot of micro decisions in micro seconds. Plan your risk/reward strategies and execute them wisely"
]

onready var label := $ColorRect/Label

export var tutorial_index := 0

var tabs := 1

func _ready() -> void:
	$ColorRect/Button.text = "OK - Next tutorial (Tab - Select)"
	label.text = tutorials[tutorial_index]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		tabs += 1
		if tabs == 19:
			get_tree().change_scene("res://game/ui/menus/Menu.tscn")
		if tabs % 2 == 0:
			show_tutorial()
		else:
			try_tutorial()
		


func try_tutorial() -> void:
	$ColorRect/Button.text = "OK - Next tutorial (Tab - Select)"
	get_tree().paused = false


func show_tutorial() -> void:
	$ColorRect/Button.text = "OK - Let's try (Tab - Select)"
	tutorial_index += 1
	label.text = tutorials[tutorial_index]
	get_tree().paused = true
	check_tutorial()

func check_tutorial() -> void:
	if tutorial_index == 3:
		Events.emit_signal("fuelled_drone_bar")
		Events.emit_signal("send_dummy_enemies", false)
	elif tutorial_index == 4:
		Events.emit_signal("fuelled_drone_bar")
		Events.emit_signal("send_dummy_enemies", false)
	elif tutorial_index == 5:
		Events.emit_signal("send_i_bullers_enemies")
	elif tutorial_index == 6:
		Events.emit_signal("send_dummy_enemies", true) #100% scrap chance
	elif tutorial_index == 7:
		Events.emit_signal("send_rotator_enemy")
	elif tutorial_index == 8:
		Events.emit_signal("send_aimers_enemies")
	elif tutorial_index == 9:
		$ColorRect/Button.text = "OK - Back to Menu (Tab - Select)"
