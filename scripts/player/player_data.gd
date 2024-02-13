extends Resource
class_name PlayerData

@export var gravity: float = 20.0
@export var base_speed: float = 5.0
@export_range(0.0, 1.0) var base_acceleration: float = 0.25
@export_range(0.0, 1.0) var air_multiplier: float = 0.5
#@export var sprint_multiplier: float = 1.5
#@export var sneak_multiplier: float = 0.5
@export var jump_velocity: float = 6
@export var max_air_jumps: int = 1

@export var skin_color: StandardMaterial3D

@export var footstep_sound: AudioStream
@export var footstep_pitch: float = 1.0

