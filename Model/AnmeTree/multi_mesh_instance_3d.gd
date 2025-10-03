extends MultiMeshInstance3D

# Gradient colors (start and end)
@export var gradient_start: Color = Color.RED
@export var gradient_end: Color = Color.BLUE
@export var instance_count: int = 100

# Optional: arrange instances in a pattern
@export var spacing: float = 2.0
@export var grid_size: int = 10  # For grid arrangement

func _ready():
	setup_multimesh()
	apply_gradient_colors()

func setup_multimesh():
	# Create a new MultiMesh if one doesn't exist
	if multimesh == null:
		multimesh = MultiMesh.new()
	
	# Set the mesh (you can assign any mesh you want)
	if multimesh.mesh == null:
		# Create a simple box mesh as example
		var box_mesh = BoxMesh.new()
		box_mesh.size = Vector3(1, 1, 1)
		multimesh.mesh = box_mesh
	
	# Configure MultiMesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_colors = true  # Enable per-instance colors
	multimesh.instance_count = instance_count
	
	# Create unshaded material
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true  # Use vertex colors as albedo
	multimesh.mesh.surface_set_material(0, material)
	
	# Position instances (example: grid layout)
	var idx = 0
	for x in range(grid_size):
		for z in range(grid_size):
			if idx >= instance_count:
				break
			
			var transform = Transform3D()
			transform.origin = Vector3(x * spacing, 0, z * spacing)
			multimesh.set_instance_transform(idx, transform)
			idx += 1

func apply_gradient_colors():
	# Apply gradient colors to each instance
	for i in range(multimesh.instance_count):
		# Calculate the interpolation factor (0.0 to 1.0)
		var t = float(i) / float(multimesh.instance_count - 1)
		
		# Interpolate between start and end colors
		var color = gradient_start.lerp(gradient_end, t)
		
		# Set the color for this instance
		multimesh.set_instance_color(i, color)

# Optional: Update gradient colors at runtime
func update_gradient(new_start: Color, new_end: Color):
	gradient_start = new_start
	gradient_end = new_end
	apply_gradient_colors()

# Optional: Set individual instance color
func set_instance_custom_color(instance_idx: int, color: Color):
	if instance_idx >= 0 and instance_idx < multimesh.instance_count:
		multimesh.set_instance_color(instance_idx, color)
