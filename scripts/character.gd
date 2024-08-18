extends CharacterBody2D

@export var speed = 100
@export var friction = 0.9
@export var acceleration = 0.9

@export var shrink_time: int = 600

@onready var camera_2d: Camera2D = $Camera2D
@onready var shrink_timer: Timer = $ShrinkTimer
@onready var scale_bar: ProgressBar = $CanvasLayer/ScaleBar

var initial_scale = 1
@export var initial_zoom = 2

func _ready() -> void:
	shrink_timer.wait_time = shrink_time
	shrink_timer.start()

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(delta):
	var scale_factor = shrink_timer.time_left / shrink_time
	set_scale(Vector2(initial_scale * scale_factor, initial_scale * scale_factor))
	camera_2d.set_zoom(Vector2(initial_zoom / scale_factor, initial_zoom / scale_factor))
	scale_bar.value = 100 * scale_factor
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
