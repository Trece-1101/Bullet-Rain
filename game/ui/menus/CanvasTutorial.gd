extends CanvasLayer

onready var tutorials := [
	"Welcome to the [b]tutorial[/b]\nWait a second... your ship is [shake rate=3 level=8][color=red]spawning[/color][/shake] with his fantastic cover shield mode [shake rate=2 level=6][color=red]ON[/color][/shake]",
	"[b]Movement[/b]\nYour ship moves [shake rate=3 level=8][color=red]faster[/color][/shake] when is not shooting. Move with [i]AD[/i] or [i]Left Stick[/i]. Shoot with [i]left clic[/i] or [i]Right Trigger[/i] and feel the (tiny) difference\nAlso, when you [shake rate=3 level=8][color=red]move foward[/color][/shake] your bullets are a little bit [shake rate=3 level=8][color=red]faster.[/color][/shake]\nGet all that momentum!",
	"[b]Shooting[/b]\nYou have 2 types of bullets.\n[shake rate=3 level=8][color=red]Primary (Red):[/color][/shake] Faster and makes more damage, but can't destroy yellow enemies bullets\n[shake rate=3 level=8][color=yellow]Secondary (Yellow):[/color][/shake] Slower and makes less damage, but can destroy any (Yellow) enemy bullet\nChange your bullet type with [i]Right Clic[/i] or [i]Left Trigger[/i]. You don't need to stop shooting in order to change bullets, just press change button/clic while shooting!!!",
	"[b]Drone[/b]\nYour 'Drone bar' (Right side of HUD) [shake rate=3 level=8][color=red]replenish[/color][/shake] with time and killing enemies. When is full you can call, with [i]CTRL[/i] or [i]West Button Gamepad[/i], 2 drones that can [wave amp=50 freq=2][color=red]shoot[/color][/wave] and provide a [wave amp=50 freq=2][color=red]shield[/color][/wave] each one!",
	"[b]Ultimate[/b]\nYour 'Ultimate bar' (Right side of HUD) [shake rate=3 level=8][color=red]replenish[/color][/shake] with time and killing enemies. When is full you can call with [i]Space[/i] or [i]South Button Gamepad[/i] the true power of your ship!\n\n\n[color=yellow]Yellow Ship:[/color] destroy all bullets on screen.\n[color=aqua]Blue Ship:[/color] invulnerability\n[color=red]Red Ship:[/color] shoot missiles",
	"[b]Enemy Bullets[/b]\nEnemies can shoot 2 types of bullets\n[shake rate=3 level=8][color=yellow]Yellow:[/color][/shake] this bullet [i]can[/i] be destroy with your yellow bullet.\n[shake rate=3 level=8][color=purple]Purple:[/color][/shake] this bullet [i]can only[/i] be destroy with [i]ultimate[/i] powers and no other way",
	"[b]Scrap[/b]\nAll enemies [i]can[/i] provide scrap, the [i]harder[/i] the enemy [i]better[/i] the [i]chance[/i]. You have to chase the scrap [wave amp=50 freq=2][color=red]before is gone[/color][/wave], it last a few seconds and vanished. [i]Only[/i] with scrap you can [i]buy upgrades[/i] for your ships.\nThis can be done at the en of the level on the [i]'Hangar'[/i]",
	"[b]Enemies[/b]\nThere are all kinds of enemies. Some of them are [i]rotators[/i]. Try to understand their behavior when the game is still easy. Then you won't have the chance to look at them. On Bullet Rain... bullets are priority",
	"[b]Enemies[/b]\nThere are all kinds of enemies. Some of them will [i]aim[/i] towards you. Some will [i]chase[/i] you. Some of them have [i]minions[/i] for protection. Others can [i]appear and disappear[/i] from screen.\nEach level has a [wave amp=50 freq=2][color=red]'mid' boss[/color][/wave] and a [wave amp=50 freq=2][color=red]final boos[/color][/wave], [b]Hard Mode ON[/b]",
	"[b]That's about it[/b]\nBullet Rain is about a [shake rate=3 level=8][color=red]lot of micro decisions in micro seconds[/color][/shake].\n[b]Plan your risk/reward strategy and execute it wisely[/b]"
]

onready var label := $ColorRect/Label
onready var rich_label := $ColorRect/RichTextLabel

export var tutorial_index := 0

var tabs := 1

func _ready() -> void:
	$ColorRect/Button.text = "OK - Next tutorial (Tab - Select)"
	rich_label.bbcode_text = tutorials[tutorial_index]


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
	rich_label.bbcode_text = tutorials[tutorial_index]
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
