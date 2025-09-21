extends Area3D

@export var outline_sprite: Sprite3D
var has_triggered: bool = false

var prompt_tween: Tween
var prompt_timer: Timer

func _ready():
	outline_sprite = $"../Sprite3D"
	
	# Connect the Area3D signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Initializations
	if outline_sprite:
		outline_sprite.visible = false
	if PromptText:
		PromptText.modulate.a = 0.0
		PromptText.visible = false
	
	# Creating a Timer instance for display duration
	prompt_timer = Timer.new()
	prompt_timer.wait_time = 5.0
	prompt_timer.one_shot = true
	prompt_timer.timeout.connect(_on_prompt_timeout)
	add_child(prompt_timer)

func _on_body_entered(body):
	if body is CharacterBody3D:  
		show_interaction()

func _on_body_exited(body):
	if body is CharacterBody3D:  
		hide_interaction()

func show_interaction():
	if outline_sprite:
		outline_sprite.visible = true
	
	if PromptText and not has_triggered:
		PromptText.visible = true
		if prompt_tween:
			prompt_tween.kill()
		prompt_tween = create_tween() # Tween is for gradually changing values
		prompt_tween.tween_property(PromptText, "modulate:a", 1.0, 0.5)
		has_triggered = true
		
		prompt_timer.start()

func hide_interaction():
	if outline_sprite:
		outline_sprite.visible = false

func _on_prompt_timeout():
	if PromptText:
		prompt_tween = create_tween() # Tween is for gradually changing values
		prompt_tween.tween_property(PromptText, "modulate:a", 0.0, 0.5)
