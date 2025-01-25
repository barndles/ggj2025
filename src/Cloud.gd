extends Area2D

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	$Sprite2D.set_texture(load("res://gfx/Cloud" + str(random.randi_range(1, 4)) + ".png"))
