extends Control

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

var intro: bool = true
var introCount: int = 0
var interrupted: bool = false

var score: int = 0
var second: int = 0
var minute: int = 0

var bublinkoIntroPhrases: Array[Array] = [
	["Welcome to MR BUBLINKO'S BIG BEAUTIFUL PACHINKO BALLAPALOOZA.", 2],
	["My name is Mr. Bublinko, and I am your friendly neighborhood bubble man.", 3],
	["That little ball is you. Don’t stress yourself out about it. If the ball goes in a direction you don’t like, shake your mouse to send it the other way.", 3],
	["See those balloon animals? Don’t touch those, or you’ll lose points.", 3],
	["Like, please don’t touch them.", 2],
	["There are a few power-ups too, those are for you to figure out what they do.", 3],
	["Again, don’t touch the balloon animals.", 2]
	]

var bublinkoInterrupted: Array[Array] = [
	["Ok fine, ignore my instructions, you're on your own.", 2],
	["NO! STOP! Don't touch those! They're BAD!", 2],
	["...you're not very patient, are you?", 2]
]

var bublinkoEscaped: Array[Array] = [
	["Hey, where'd you go?", 1],
	["Whoa.", 0.25],
	["I meant to fix that, sorry.", 1],
	["Whoops, my bad", 0.25],
	["NO STOP YOU'RE GONNA BREAK IT GET BACK HERE NOOOOOOOOOOOO", 2],
	["Gonna crash this game with NO SURVIVORS", 1]
]

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	call_deferred("pivotFix")
	var tween1: Tween = get_tree().create_tween()
	tween1.tween_property($Fader, "color", Color(0, 0, 0, 0), 1)
	await tween1.finished
	var tween2: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING)
	tween2.tween_property($BublinkoContainer, "position:y", 8, 0.75)
	await tween2.finished
	bublinkoRotate()
	bublinkoSpeak(bublinkoIntroPhrases[introCount])

func pivotFix() -> void:
	await get_tree().process_frame
	%Bublinko.pivot_offset = %Bublinko.size / 2

func _input(_input: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_interrupt"):
		introInterrupt()
	if Input.is_action_just_pressed("debug_escapeBoard"):
		playerEscape()

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
	tween.tween_property(%Bublinko, "rotation_degrees", random.randi_range(-50, 50), %RotateTimer.wait_time)
	%RotateTimer.start()

func _on_intro_phrase_timer_timeout() -> void:
	introCount += 1
	if not interrupted:
		if bublinkoIntroPhrases.size() - 1 >= introCount:
			bublinkoSpeak(bublinkoIntroPhrases[introCount])
		else:
			intro = false
			%BublinkoText.text = ""

func bublinkoSpeak(phrase: Array) -> void:
	var tween = create_tween()
	if intro:
		tween.tween_method(bublinkoText, "", phrase[0], phrase[1])
		await tween.finished
		if not interrupted:
			$IntroPhraseTimer.start()

func bublinkoText(text: String) -> void:
	%BublinkoText.text = text

func introInterrupt() -> void: # if player collects animals while bublinko is still speaking
	interrupted = true
	bublinkoSpeak(bublinkoInterrupted.pick_random())

func playerEscape() -> void: # if player escapes the board
	var phrase: Array = bublinkoEscaped.pick_random()
	interrupted = true
	bublinkoSpeak(phrase)
	await get_tree().create_timer(phrase[1]).timeout
	get_tree().quit()
