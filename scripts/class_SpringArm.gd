extends Node3D
class_name SpringArm

const ROTATE_SPEED : float = 1.0
const PITCH_MIN : float = -22
const PITCH_MAX : float = 45

@export var RayCast : SpringArm3D
@export var Camera : Camera3D
@export var TargetArea : Area3D
@export var TargetRay : RayCast3D

@onready var CameraPosition : Marker3D = $SpringArm3D/CameraPosition

func _process(delta):
	Camera.global_position = lerp(Camera.global_position, CameraPosition.global_position, delta * 10)
	
	Camera.global_rotation.x = lerp_angle(Camera.global_rotation.x, CameraPosition.global_rotation.x, 0.05)
	Camera.global_rotation.y = lerp_angle(Camera.global_rotation.y, CameraPosition.global_rotation.y, 0.05)
	Camera.global_rotation.z = lerp_angle(Camera.global_rotation.z, CameraPosition.global_rotation.z, 0.05)
	
func move(rotation : Vector3)->void:
	global_rotation.x = lerp_angle(global_rotation.x, rotation.x, 0.1)
	global_rotation.y = lerp_angle(global_rotation.y, rotation.y, 0.1)
	
func move_add(rotation : Vector3)->void:
	global_rotation.x += rotation.x
	global_rotation.y += rotation.y
	global_rotation.x = clamp(global_rotation.x, deg_to_rad(PITCH_MIN), deg_to_rad(PITCH_MAX))
	
func get_rotation_view()->Vector2:
	return Vector2(global_rotation.y, global_rotation.x)
	
func get_camera_position()->Vector3:
	return CameraPosition.global_position
	
func get_camera_rotation()->Vector3:
	return CameraPosition.global_rotation

func calc_input_direction(input : Vector2)->Vector3:
	var vector_fwd : Vector3 = Vector3(0,0,1).rotated(Vector3.UP, CameraPosition.global_rotation.y)
	var vector_hor : Vector3 = Vector3(1,0,0).rotated(Vector3.UP, CameraPosition.global_rotation.y)
	return (vector_fwd * input.y + vector_hor * input.x)
	
