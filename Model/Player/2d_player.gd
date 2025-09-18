extends CharacterBody3D

@export var speed: float = 5.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var anim_sprite: AnimatedSprite3D = $AnimatedSprite3D

# For action item detection
var can_interact: bool = false
var current_action_item: Node = null

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Input: only left and right (X axis)
	var input_dir := 0
	if Input.is_action_pressed("ui_right"):
		input_dir += 1
	if Input.is_action_pressed("ui_left"):
		input_dir -= 1

	velocity.x = input_dir * speed
	velocity.z = 0   # lock Z movement

	# Movement
	move_and_slide()

	# Flip sprite if moving left
	if input_dir < 0:
		anim_sprite.flip_h = true
	elif input_dir > 0:
		anim_sprite.flip_h = false

	# Animation switching
	if input_dir == 0:
		anim_sprite.play("idle")
	else:
		anim_sprite.play("run")

	# Handle interaction
	if can_interact and Input.is_action_just_pressed("ui_accept"):
		if current_action_item:
			current_action_item.trigger_action(self)
