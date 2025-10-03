extends DirectionalLight3D

@export var rotation_speed: float = 30.0 # degrees per second
var angle: float = 0.0
@export var fixed_z: float = -90.0 # sunrise/sunset tilt

func _process(delta: float) -> void:
	angle += rotation_speed * delta
	rotation_degrees = Vector3(angle, -60, 0)
