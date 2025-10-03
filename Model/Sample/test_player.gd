extends CharacterBody3D

@export var lateral_speed: float = 3.0
var lateral_offset: float = 0.0

func _process(delta: float) -> void:
	var dir := 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1

	lateral_offset += dir * lateral_speed * delta

	var path := get_parent() as PathFollow3D
	if path:
		global_transform.origin = path.global_transform.origin + path.global_transform.basis.x * lateral_offset
		global_transform.basis = path.global_transform.basis
