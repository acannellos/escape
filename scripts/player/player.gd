extends CharacterBody3D
class_name Player

@export var human_data: PlayerData
@export var vampire_data: PlayerData

var is_vampire: bool = false

var data: PlayerData

var speed: float = 5.0
var acceleration: float = 0.25
var input_dir: Vector2
var direction: Vector3
var jump_phase: int = 0

var sensitivity: float = 0.001

@onready var head = $head
@onready var camera = $head/camera
@onready var sub_viewport = $head/camera/SubViewportContainer/SubViewport
@onready var sub_camera = $head/camera/SubViewportContainer/SubViewport/sub_camera

@onready var collision = $CollisionShape3D

@onready var footsteps = $footsteps

var previously_floored: bool = false

func _ready():
	data = human_data
	#Globals.player = self
	sub_viewport.size = DisplayServer.window_get_size()
	
	set_data()

func set_data():
	footsteps.stream = data.footstep_sound
	footsteps.pitch_scale = data.footstep_pitch
	footsteps.play()
	
	sub_camera.color = data.skin_color
	sub_camera.set_mat()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_head(event, sensitivity)
		sub_camera.sway(Vector2(event.relative.x, event.relative.y))
		#print(event.relative.x)

	if event.is_action_pressed("jump") and can_jump():
		jump()
	
	if event.is_action_pressed("action_2"):
		is_vampire = true
		data = vampire_data
		set_data()
		#collision.disabled = true
		footsteps.stream_paused = false
	
	if event.is_action_released("action_2"):
		is_vampire = false
		data = human_data
		set_data()
		#Audio.play("assets/sounds/player_land.wav")
		#collision.disabled = false

func _physics_process(delta):
	
	if footsteps.stream == null:
		footsteps.set_stream(data.footstep_sound)
		print("cool")
	
	handle_grounded(delta)
	handle_movement(delta)
	#sub_camera.global_transform = camera.global_transform
	sub_camera.global_transform = head.global_transform
	
	if is_on_floor() and !previously_floored:
		Audio.play("assets/sounds/player_land.wav")
		#camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
	if position.y < -10:
		get_tree().reload_current_scene()

#func rotate_head(event, sensitivity):
	#head.rotate_y(-event.relative.x * sensitivity)
	#camera.rotate_x(-event.relative.y * sensitivity)
	#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-88.0), deg_to_rad(88.0))

func handle_grounded(delta):	
	if not is_on_floor():
		velocity.y -= data.gravity * delta
		acceleration = data.base_acceleration * data.air_multiplier
		
		if not is_vampire:
			footsteps.stream_paused = true
	else:
		jump_phase = data.max_air_jumps
		acceleration = data.base_acceleration
		if input_dir:
			footsteps.stream_paused = false
		else:
			if not is_vampire:
				footsteps.stream_paused = true

func handle_movement(delta):
	speed = data.base_speed
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	if input_dir:
		direction = head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)
		direction.normalized()
		sub_camera.sway(Vector2(input_dir.x * 100, -abs(input_dir.y) * 100))
	else:
		direction = Vector3.ZERO
	
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	move_and_slide()
	#sub_camera.sway(Vector2(velocity.x*10, velocity.z*10))
	#sub_camera.sway(Vector2(input_dir.x * 100, -abs(input_dir.y) * 100))

func can_jump() -> bool:
	return (is_on_floor() or jump_phase > 0)

func jump():
	velocity.y = data.jump_velocity
	jump_phase -= 1
