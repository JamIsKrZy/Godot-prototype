@tool
extends Node3D

# ---- Exposed parameters ----
@export var foliage_colour: Color = Color(0.13, 0.33, 0.25) : set = _set_foliage_colour
@export_range(0.0, 2.0, 0.01) var color_strength: float = 1.0 : set = _set_color_strength
@export var fresnel_colour: Color = Color(0.5, 0.7, 0.4) : set = _set_fresnel_colour
@export_range(0.0, 1.0, 0.01) var fresnel_strength: float = 0.3 : set = _set_fresnel_strength
@export_range(0.1, 5.0, 0.01) var fresnel_power: float = 1.5 : set = _set_fresnel_power


# ---- Setters ----
func _set_foliage_colour(v: Color) -> void:
	foliage_colour = v
	_update_shader()

func _set_color_strength(v: float) -> void:
	color_strength = v
	_update_shader()

func _set_fresnel_colour(v: Color) -> void:
	fresnel_colour = v
	_update_shader()

func _set_fresnel_strength(v: float) -> void:
	fresnel_strength = v
	_update_shader()

func _set_fresnel_power(v: float) -> void:
	fresnel_power = v
	_update_shader()

# ---- Update loop ----
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): # only run this inside editor
		_update_shader()

# ---- Internal updater ----
func _update_shader() -> void:
	print($".".get_child_count(false))
	var children_nodes := $".".get_children(false)
	print(children_nodes)
	for child in children_nodes:
		print(child.name)
		if( child.get_instance_id() == $Leaf41.get_instance_id()):
			var mesh_instance := child as MeshInstance3D
			var mat := mesh_instance.get_active_material(0) as ShaderMaterial
			if mat:
				mat.set_shader_parameter("foliage_colour", foliage_colour)
				mat.set_shader_parameter("color_strength", color_strength)
				mat.set_shader_parameter("fresnel_colour", fresnel_colour)
				mat.set_shader_parameter("fresnel_strength", fresnel_strength)
				mat.set_shader_parameter("fresnel_power", fresnel_power)
