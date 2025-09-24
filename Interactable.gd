extends StaticBody3D  # or StaticBody3D

@export var prompt_text := "Press [E] to interact"

@onready var area: Area3D     = $Area3D
@onready var prompt3d: Node3D = $Prompt3D  # Label3D or Sprite3D

func _ready() -> void:
	# Optional for Label3D:
	if prompt3d is Label3D:
		(prompt3d as Label3D).text = prompt_text
	prompt3d.visible = false

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		if body.has_method("set_interactable"):
			body.set_interactable(self)
		_fade_prompt(true)

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody3D:
		if body.has_method("set_interactable") and body.current_action_item == self:
			body.set_interactable(null)
		_fade_prompt(false)

func _fade_prompt(show: bool) -> void:
	var tw := create_tween()
	if show:
		prompt3d.visible = true
		prompt3d.modulate.a = 0.0
		tw.tween_property(prompt3d, "modulate:a", 1.0, 0.12)
	else:
		tw.tween_property(prompt3d, "modulate:a", 0.0, 0.1).finished.connect(
			func(): prompt3d.visible = false
		)
# This is what your player will call on ui_accept
func trigger_action(by: Node) -> void:
	print("Interacted with %s by %s" % [name, by.name])
