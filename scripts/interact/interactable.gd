extends Node3D
class_name Interactable

@export var body: StaticBody3D
@export var label: String = ""

func _ready():
	body.set_collision_layer_value(4, true)
	#print(body.get_collision_layer_value(4))

func interact():
	pass
