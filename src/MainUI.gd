extends Control

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

var second: int = 0
var minute: int = 0

var phrases: Array[Array] = [[]]

func _ready() -> void:
	bublinkoRotate()
	bublinkoSpeak()

func _on_game_timer_timeout() -> void:
	if second + 1 == 60:
		minute += 1
		second = 0
	else:
		second += 1
	$Timer.text = str("%0*d" % [2, minute]) + ":" + str("%0*d" % [2, second])

func _on_rotate_timer_timeout() -> void:
	bublinkoRotate()

func bublinkoRotate() -> void:
	%RotateTimer.wait_time = random.randi_range(3, 7)
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Bublinko, "rotation_degrees", random.randi_range(-50, 50), %RotateTimer.wait_time)
	%RotateTimer.start()

func bublinkoSpeak() -> void:
	var tween = create_tween()
	tween.tween_method(bublinkoText, "", "hey its me mistah bublinko da bubl blowa", 1).set_delay(2)

func bublinkoText(text: String) -> void:
	$BublinkoText.text = text
