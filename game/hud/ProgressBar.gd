extends ProgressBar
signal full_value

var maximus_decimus_meridius := 100 setget set_maximus_decimus_meridius
var is_full := false
var original_color: Color

func set_maximus_decimus_meridius(value_max: int) -> void:
	max_value = value_max

func _ready() -> void:
	original_color = get("custom_styles/fg").get_bg_color()
	value = 0

func update_value(s_value: int) -> void:
	value += s_value
	if value == max_value and not is_full:
		$FullSFX.play()
		is_full = true
		get("custom_styles/fg").set_bg_color(Color.red)
		emit_signal("full_value")

func reset() -> void:
	get("custom_styles/fg").set_bg_color(original_color)
	is_full = false
	value = 0
