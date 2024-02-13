extends Camera3D

@export var color: StandardMaterial3D
@export var arm_arr: Array[MeshInstance3D]

@onready var rig = $rig
@onready var arms = $rig/arms

func _ready():
	set_mat()

func set_mat():
	for child in arm_arr:
		child.set_surface_override_material(0,color)

func _physics_process(delta):
	rig.position.x = lerp(rig.position.x, 0.0, delta * 5)
	rig.position.y = lerp(rig.position.y, 0.0, delta * 5)

func sway(sway_amt):
	rig.position.x -= sway_amt.x * 0.00005
	rig.position.y += sway_amt.y * 0.00005
