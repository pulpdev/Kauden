extends Node3D
class_name SpringArm

const ROTATE_SPEED : float = 0.4

@export var Camera : Camera3D
@export var RayCast : SpringArm3D

@onready var Yaw : Node3D = $Yaw
@onready var Pitch : Node3D = $Yaw/Pitch

func set_yaw(yaw : float):
	Yaw.rotation.y = lerp(Yaw.rotation.y, yaw, ROTATE_SPEED)

func set_pitch(pitch : float)->void:
	Pitch.rotation.x = lerp(Pitch.rotation.x, pitch, ROTATE_SPEED)
	Pitch.rotation.x = clamp(Pitch.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func add_yaw(yaw : float):
	Yaw.rotation.y += yaw

func add_pitch(pitch : float)->void:
	Pitch.rotation.x += pitch
	Pitch.rotation.x = clamp(Pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func get_yaw()->float:
	return Yaw.rotation.y
	
func get_pitch()->float:
	return Pitch.rotation.x
	
func get_yaw_direction()->Vector3:
	return Yaw.global_transform.basis.z
	
func calc_input_direction(input : Vector2)->Vector3:
	var vector_fwd : Vector3 = Vector3(0,0,1).rotated(Vector3.UP, Camera.global_rotation.y)
	var vector_hor : Vector3 = Vector3(1,0,0).rotated(Vector3.UP, Camera.global_rotation.y)
	return (vector_fwd * input.y + vector_hor * input.x)
