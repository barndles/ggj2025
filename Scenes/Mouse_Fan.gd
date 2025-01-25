extends Node2D

@export var Target:RigidBody2D

var mouse_position = Vector2(0,0)
var mouse_previous_frame_position = Vector2(0,0)
var ball_position = Vector2(0,0)
var blowing_vector = Vector2(0,0)

var mouse_speed = 0
@export var blowing_power = 0.01


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Target == null:
		return
	mouse_position = get_global_mouse_position()
	ball_position = Target.global_position
	
	mouse_speed = mouse_position.distance_to(mouse_previous_frame_position)
	blowing_vector = (ball_position - mouse_position).normalized() * (mouse_speed * blowing_power)
	
	Target.add_constant_force(blowing_vector)
	
	mouse_previous_frame_position = mouse_position

func _draw() -> void:
	draw_line(ball_position, ball_position+blowing_vector, Color(0,0,0))
