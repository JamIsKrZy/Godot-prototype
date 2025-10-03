extends PathFollow3D

@export var speed: float = 3.0

func _process(delta: float) -> void:
	var move_input = 0.0
	if Input.is_action_pressed("ui_right"):
		print("go right")
		move_input += 1.0
	if Input.is_action_pressed("ui_left"):
		print("go left")
		move_input -= 1.0

	print("huh")
	if move_input != 0.0:
		progress_ratio += move_input * speed * delta
