extends Node

@onready var text_box_scene = preload("res://Textboc/text_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index := 0
var text_box: MarginContainer
var follow_target: Node3D = null   # The player or NPC we're following
var offset: Vector3 = Vector3(0, 2, 0)  # Offset above target

var is_dialog_active := false
var can_advance_line := false

# Start dialog, following a target Node3D
func start_dialog(target: Node3D, lines: Array[String]) -> void:
	if is_dialog_active:
		return

	dialog_lines = lines
	follow_target = target
	current_line_index = 0
	is_dialog_active = true
	_show_text_box()

func _show_text_box() -> void:
	var camera := get_viewport().get_camera_3d()
	if not camera:
		push_error("No Camera3D found in viewport!")
		return

	var world_pos: Vector3 = follow_target.global_position + offset
	var screen_pos: Vector2 = camera.unproject_position(world_pos)

	text_box = text_box_scene.instantiate()
	text_box.position = screen_pos
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().current_scene.add_child(text_box)

	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false

func _process(delta: float) -> void:
	if is_dialog_active and text_box and follow_target:
		var camera := get_viewport().get_camera_3d()
		if camera:
			var world_pos: Vector3 = follow_target.global_position + offset
			var target_screen_pos: Vector2 = camera.unproject_position(world_pos)

			# Smooth only horizontally, lock vertical
			var smoothed := text_box.position.lerp(target_screen_pos, delta * 10.0)
			text_box.position.x = smoothed.x
			text_box.position.y = target_screen_pos.y

func _on_text_box_finished_displaying() -> void:
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Dialog") and is_dialog_active and can_advance_line:
		text_box.queue_free()
		current_line_index += 1

		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			follow_target = null
		else:
			_show_text_box()
