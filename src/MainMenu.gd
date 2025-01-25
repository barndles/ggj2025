extends Control

@onready var cloudScene: PackedScene = preload("res://Scenes/Cloud.tscn")

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

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

func _on_boundary_area_entered(area: Area2D) -> void:
	if area.name.substr(0, 4) == "Cloud":
		var cloud: Area2D = cloudScene.insantiate()
		if area.global_position.x < 0:
			cloud.global_position = Vector2(1312, random.randi_range(10, 330))
		else:
			cloud.global_position = Vector2(-1312, random.randi_range(10, 330))
		%Clouds.add_child(cloud)
		cloud.owner = %Clouds
		area.queue_free()
