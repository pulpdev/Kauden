extends Node3D
class_name SpringArm

const ROTATE_SPEED : float = 0.05
const PITCH_MIN : float = -45
const PITCH_MAX : float = 45

@export var Camera : Camera3D
@export var RayCast : SpringArm3D

@onready var Yaw : Node3D = $Yaw
@onready var Pitch : Node3D = $Yaw/Pitch

var destination_yaw : Vector3
var reset : bool

func set_yaw(yaw : float, speed : float = ROTATE_SPEED):
	Yaw.rotation.y = rotate_toward(Yaw.rotation.y, yaw, speed)

func set_pitch(pitch : float, speed : float = ROTATE_SPEED)->void:
	Pitch.rotation.x = rotate_toward(Pitch.rotation.x, pitch, speed)
	Pitch.rotation.x = clamp(Pitch.rotation.x, deg_to_rad(PITCH_MIN), deg_to_rad(PITCH_MAX))

func add_yaw(yaw : float):
	Yaw.rotation.y += yaw

func add_pitch(pitch : float)->void:
	Pitch.rotation.x += pitch
	Pitch.rotation.x = clamp(Pitch.rotation.x, deg_to_rad(PITCH_MIN), deg_to_rad(PITCH_MAX))

func get_yaw()->float:
	return Yaw.rotation.y

func get_pitch()->float:
	return Pitch.rotation.x

func get_yaw_direction()->Vector3:
	return Yaw.global_transform.basis.z

func is_yaw_near_vector(vector : Vector3)->bool:
	return Yaw.rotation.distance_to(vector) < 0.1

func calc_input_direction(input : Vector2)->Vector3:
	var vector_fwd : Vector3 = Vector3(0,0,1).rotated(Vector3.UP, Camera.global_rotation.y)
	var vector_hor : Vector3 = Vector3(1,0,0).rotated(Vector3.UP, Camera.global_rotation.y)
	return (vector_fwd * input.y + vector_hor * input.x)
