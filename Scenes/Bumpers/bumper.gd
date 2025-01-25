extends Node2D

@onready var bumper: Node2D = $"."

var launch_angle = Vector2(0,0)
var launch_vector = Vector2(0,0)
@export var launch_power = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: RigidBody2D) -> void:

	launch_angle = (body.global_position - bumper.global_position).normalized()
	launch_vector = launch_angle * launch_power
	
	if body == null:
		return
	else:
		print(launch_vector)
		body.apply_impulse(launch_vector)
	
