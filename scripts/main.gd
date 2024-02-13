extends Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
