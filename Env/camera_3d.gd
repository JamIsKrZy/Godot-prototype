extends Camera3D

@onready var target: Node3D = $"../2dPlayer"

# adjust this until it matches your character's head/face height
@export var look_offset: Vector3 = Vector3(0, 1.7, 0)  

func _process(delta: float) -> void:
	global_position.x = target.global_position.x + 10
	global_position.y = target.global_position.y + 5
	global_position.z = target.global_position.z

	# look at the target, but offset upwards toward the face
	look_at(target.global_position + look_offset, Vector3.UP)
