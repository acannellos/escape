extends Node3D

@onready var camera = $camera

func rotate_head(event, sensitivity):
	rotate_y(-event.relative.x * sensitivity)
	camera.rotate_x(-event.relative.y * sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-88.0), deg_to_rad(88.0))
