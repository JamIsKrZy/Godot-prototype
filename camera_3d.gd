extends Camera3D

@onready var target: Node3D = $"../2dPlayer" #assign your player in Inspector

func _process(delta):
	global_position.x = target.global_position.x
