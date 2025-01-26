extends Control

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

var intro: bool = true
var introCount: int = 0
var interrupted: bool = false
var speaking: bool = false
var bublinkoAnger: int = 0

var score: int = 0
var second: int = 0
var minute: int = 0

var bublinkoIntroPhrases: Array[Array] = [
	["Welcome to MR BUBLINKO'S BIG BEAUTIFUL PACHINKO BALLAPALOOZA.", 2],
	["My name is Mr. Bublinko, and I am your friendly neighborhood bubble man.", 3],
	["That little ball is you. Don’t stress yourself out about it. If the ball goes in a direction you don’t like, shake your mouse to send it the other way.", 3],
	["See those balloon animals? Don’t touch those, or you’ll lose points.", 3],
	["Like, please, don’t touch them.", 1],
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

var bublinkoCollect: Array[Array] = [
	["Hey, I don’t know if you heard me the first time, which is okay, but please don’t touch the balloon animals.", 3],
	["Hey buddy, it’s Mr. Bublinko again, I saw you touch one of those balloon animals. I guess you weren’t paying attention, but PLEASE don’t touch them.", 4],
	["Alright, player, the joke's over, stop touching the balloon animals, you will continue to lose points if you do.", 3],
	["You're starting to make me really angry. Stop touching the balloon animals.", 3],
	["I’m warning you, if you continue to touch those balloon animals, there are going to be consequences.", 3],
	["Were instructions not clear enough to you? What did you not understand?? DON'T TOUCH THE BALLOON ANIMALS!", 3],
	["COME ON MAN! YOU ARE CLEARLY NOT LISTENING! I’M TIRED OF WARNING YOU! ENOUGH!", 3]
]

var speechDict: Dictionary = {
	0: load("res://sfx/bablinko/high/DontKnowIfYouHeardMe.ogg"),
	1: load("res://sfx/bablinko/high/HeyBuddy.ogg"),
	2: load("res://sfx/bablinko/high/AlrightJokesOver.ogg"),
	3: load("res://sfx/bablinko/high/MakingMeReallyAngry.ogg"),
	4: load("res://sfx/bablinko/high/ImWarningYou.ogg"),
	5: load("res://sfx/bablinko/high/InstructionsNotClear.ogg"),
	6: load("res://sfx/bablinko/high/ComeOnMan.ogg")
}

var emotes: Array = [
	load("res://gfx/bublinko/happy.png"),
	load("res://gfx/bublinko/smile.png"),
	load("res://gfx/bublinko/neutral.png"),
	load("res://gfx/bublinko/confused.png"),
	load("res://gfx/bublinko/annoyed.png"),
	load("res://gfx/bublinko/shocked.png"),
	load("res://gfx/bublinko/upset.png"),
	load("res://gfx/bublinko/angry.png")
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
	$BublinkoSpeechIntro.play()
	bublinkoSpeak(bublinkoIntroPhrases[introCount])

func pivotFix() -> void:
	await get_tree().process_frame
	%Bublinko.pivot_offset = %Bublinko.size / 2

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
			#$BublinkoSpeechIntro.get_stream().set_list_stream(introCount, $BublinkoSpeechIntro.get_stream())
			#$BublinkoSpeechIntro.play()
			bublinkoSpeak(bublinkoIntroPhrases[introCount])
		else:
			intro = false
			$BublinkoSpeechIntro.stop()
			%BublinkoText.text = ""

func bublinkoSpeak(phrase: Array) -> void:
	var tween = create_tween()
	if intro:
		print($BublinkoSpeechIntro.get_stream().get_length())
		tween.tween_method(bublinkoText, "", phrase[0], $BublinkoSpeechIntro.get_stream().get_length())
		await tween.finished
		if not interrupted:
			$IntroPhraseTimer.start()
	else:
		if bublinkoCollect.size() - 1 >= bublinkoAnger:
			speaking = true
			$BublinkoSpeechIntro.stop()
			$BublinkoSpeech.set_stream(speechDict[bublinkoAnger])
			$BublinkoSpeech.play()
			tween.tween_method(bublinkoText, "", bublinkoCollect[bublinkoAnger][0], $BublinkoSpeech.get_stream().get_length())
			%Bublinko.set_texture(emotes[bublinkoAnger])
			await tween.finished
			speaking = false
	await get_tree().create_timer(5).timeout
	if not speaking:
		%BublinkoText.text = ""

func bublinkoText(text: String) -> void:
	%BublinkoText.text = text

func introInterrupt() -> void: # if player collects animals while bublinko is still speaking
	interrupted = true
	intro = false
	$BublinkoSpeechIntro.stop()
	bublinkoSpeak(bublinkoInterrupted.pick_random())

func playerEscape() -> void: # if player escapes the board
	var phrase: Array = bublinkoEscaped.pick_random()
	interrupted = true
	bublinkoSpeak(phrase)
	await get_tree().create_timer(phrase[1] - 0.25).timeout
	get_tree().quit()

func gameOver() -> void:
	pass
