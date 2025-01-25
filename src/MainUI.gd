extends Control

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

var intro: bool = true
var introCount: int = 0

var second: int = 0
var minute: int = 0

var bublinkoIntroPhrases: Array[Array] = [
	["Welcome to MR BUBLINKO'S BIG BEAUTIFUL PACHINKO BALLAPALOOZA.", 2],
	["My name is Mr. Bublinko, and I am your friendly neighborhood bubble man.", 2],
	["That little ball is you. Don’t stress yourself out about it. If the ball goes in a direction you don’t like, shake your mouse to send it the other direction.", 2],
	["See those balloon animals? Don’t touch those, you’ll lose points.", 2],
	["Like just to make sure I said it, please don’t touch them.", 2],
	["There are a few power-ups too, but those are for you to figure out what they will do.", 2],
	["Again, don’t touch the balloon animals.", 2]
	]

func _ready() -> void:
	bublinkoRotate()
	bublinkoSpeak(bublinkoIntroPhrases[introCount])

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

func _on_intro_phrase_timer_timeout() -> void:
	introCount += 1
	if bublinkoIntroPhrases.size() >= introCount:
		bublinkoSpeak(bublinkoIntroPhrases[introCount])

func bublinkoSpeak(phrase: Array) -> void:
	var tween = create_tween()
	if intro:
		tween.tween_method(bublinkoText, "", phrase[0], phrase[1])
		await tween.finished
		$IntroPhraseTimer.start()

func bublinkoText(text: String) -> void:
	$BublinkoText.text = text
