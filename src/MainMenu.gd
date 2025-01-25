extends Control

func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Fader, "color", Color(0, 0, 0, 0), 1)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Fader, "color", Color(0, 0, 0, 1), 1)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/Levels/Level-1.tscn")
