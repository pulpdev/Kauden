extends Node3D
class_name SpringArm

const ROTATE_SPEED : float = 1.0
const PITCH_MIN : float = -12
const PITCH_MAX : float = 45

enum CONTROL_SCHEMES {
	KEYBOARD_MOUSE = 0,
	GAMEPAD = 1
}

signal control_scheme_changed(scheme : int)

@export var RayCast : SpringArm3D
@export var Camera : Camera3D
@export var TargetArea : Area3D
@export var TargetRay : RayCast3D

@onready var CameraPosition = $SpringArm3D/CameraPosition

var vector_mouse : Vector2
var vector_joystick : Vector2
var sensitivity_mouse : float = 0.4
var sensitivity_joystick : float = 0.03
var control_scheme : CONTROL_SCHEMES = CONTROL_SCHEMES.KEYBOARD_MOUSE:
	set(x):
		if not control_scheme == x:
			control_scheme = x
			control_scheme_changed.emit(control_scheme)

var vector_reset : Vector3
var resetting : bool
var resettimer : Timer
var weight_camera : Vector2 = Vector2(8,24)

func _ready():
	resettimer = Timer.new()
	resettimer.autostart = false
	resettimer.one_shot = true
	resettimer.wait_time = 0.2
	resettimer.timeout.connect(func(): resetting = false)
	add_child(resettimer)
	
	vector_mouse = get_rotation_view()

func _process(delta):
	Camera.global_position = lerp(Camera.global_position, CameraPosition.global_position, delta * weight_camera.x)
	Camera.global_rotation.x = lerp_angle(Camera.global_rotation.x, CameraPosition.global_rotation.x, delta * weight_camera.y)
	Camera.global_rotation.y = lerp_angle(Camera.global_rotation.y, CameraPosition.global_rotation.y, delta * weight_camera.y)
	Camera.global_rotation.z = lerp_angle(Camera.global_rotation.z, CameraPosition.global_rotation.z, delta * weight_camera.y)

	if resetting:
		global_rotation.x = lerp_angle(global_rotation.x, vector_reset.x, delta * 20)
		global_rotation.y = lerp_angle(global_rotation.y, vector_reset.y, delta * 20)
		if is_near_rotation(vector_reset) and resettimer.is_stopped():
			resettimer.start()

func view_reset(rotation : Vector3)->void:
	if resettimer.is_stopped():
		vector_reset = rotation
		resetting = true
	
func is_resetting()->bool:
	return resetting

func move(rotation : Vector3, min : float = PITCH_MIN, max : float = PITCH_MAX)->void:
	if not resetting:
		global_rotation = rotation
		global_rotation.x = clamp(global_rotation.x, deg_to_rad(min), deg_to_rad(max))
	
func move_add(rotation : Vector3, delta : float, min : float = PITCH_MIN, max : float = PITCH_MAX)->void:
	if not resetting:
		global_rotation.x += rotation.x * delta * 100
		global_rotation.y += rotation.y * delta * 100
		global_rotation.x = clamp(global_rotation.x, deg_to_rad(min), deg_to_rad(max))
	
func is_near_rotation(rotation : Vector3)->bool:
	return global_rotation.distance_to(rotation) < 0.1
	
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
	
