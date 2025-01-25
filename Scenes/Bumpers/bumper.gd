extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var bumper: Node2D = $"."

var launch_angle = Vector2(0,0)
var launch_vector = Vector2(0,0)
var launch_power = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	launch_angle = bumper.global_position.angle_to(body.global_position)
	launch_vector = launch_angle * launch_power
	
	
	
