extends Area2D

@onready var level: Node2D = get_tree().get_root().get_node("Level-1")
@onready var mainUI: Control = level.get_node("CanvasLayer/MainUI")
@onready var player: RigidBody2D = level.get_node("Player")

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	var startRotate: Array = [20, -20]
	$Sprite2D.rotation_degrees = startRotate.pick_random()
	spriteRotate()

func _input(_input: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_collectBalloon"):
		_on_body_entered(player)

func _on_rotate_timer_timeout() -> void:
	spriteRotate()

func spriteRotate() -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if $Sprite2D.rotation_degrees == 20:
		tween.tween_property($Sprite2D, "rotation_degrees", -20, 3)
	elif $Sprite2D.rotation_degrees == -20:
		tween.tween_property($Sprite2D, "rotation_degrees", 20, 3)
	else:
		printerr("bad rotate")

func _on_body_entered(body: RigidBody2D) -> void:
	if body.name == "Player":
		mainUI.score += 100
		mainUI.get_node("Score").text = "Score: " + str(mainUI.score)
		var finalRotate: Array = [20, -20]
		var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property($Sprite2D, "rotation_degrees", finalRotate.pick_random(), 0.5)
		tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 0.5)
		await tween.finished
		queue_free()
