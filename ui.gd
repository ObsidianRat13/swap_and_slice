extends Control

@export var MAIN_SCENE: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_swap") and is_visible_in_tree():
		var MAIN = MAIN_SCENE.instantiate()
		get_tree().root.add_child(MAIN)
		hide()


func _on_button_pressed() -> void:
	var MAIN = MAIN_SCENE.instantiate()
	get_tree().root.add_child(MAIN)
	hide()
