extends CharacterBody2D

@export var speed = 100
@export var friction = 0.9
@export var acceleration = 0.9

@export var shrink_time: int = 60

@onready var camera_2d: Camera2D = $Camera2D
@onready var shrink_timer: Timer = $ShrinkTimer
@onready var scale_bar: ProgressBar = $CanvasLayer/ScaleBar
@onready var marker_2d: Marker2D = $Marker2D
@onready var weapon_hitbox_collision: CollisionShape2D = $Marker2D/WeaponHitboxArea/WeaponHitboxCollision
@onready var weapon_cooldown_timer: Timer = $Marker2D/WeaponCooldownTimer
@onready var weapon_sprite: Sprite2D = $Marker2D/WeaponSprite
@onready var weapon_animation: AnimationPlayer = $Marker2D/WeaponSprite/WeaponAnimation

var initial_scale = 1
@export var initial_zoom = 2

func _ready() -> void:
	shrink_timer.wait_time = shrink_time
	shrink_timer.start()
	weapon_hitbox_collision.disabled = true
	weapon_sprite.visible = false

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		marker_2d.rotation_degrees = 0
	if Input.is_action_pressed('left'):
		input.x -= 1
		marker_2d.rotation_degrees = 180
	if Input.is_action_pressed('down'):
		input.y += 1
		marker_2d.rotation_degrees = 90
	if Input.is_action_pressed('up'):
		input.y -= 1
		marker_2d.rotation_degrees = 270
	if Input.is_action_just_pressed('attack'):
		attack()
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

func attack():
	if weapon_cooldown_timer.is_stopped():
		weapon_sprite.visible = true
		weapon_hitbox_collision.disabled = false
		weapon_animation.play()
		weapon_cooldown_timer.start()
	

func _on_weapon_hitbox_area_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		hitbox.damage(5)


func _on_weapon_cooldown_timer_timeout() -> void:
	weapon_hitbox_collision.disabled = true
	weapon_sprite.visible = false


func _on_weapon_hitbox_area_area_exited(area: Area2D) -> void:
	weapon_hitbox_collision.disabled = true
