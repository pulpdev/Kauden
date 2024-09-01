extends Node3D
class_name SpringArm

const ROTATE_SPEED : float = 1.0
const PITCH_MIN : float = -12
const PITCH_MAX : float = 45

@export var camera : Camera3D
@export var target_area : Area3D
@export var target_ray : RayCast3D

@onready var camera_position = $SpringArm3D/CameraPosition

var enabled : bool
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

func _process(delta):
	if not enabled:
		return
	camera.global_position = lerp(camera.global_position, camera_position.global_position, delta * weight_camera.x)
	camera.global_rotation.x = lerp_angle(camera.global_rotation.x, camera_position.global_rotation.x, delta * weight_camera.y)
	camera.global_rotation.y = lerp_angle(camera.global_rotation.y, camera_position.global_rotation.y, delta * weight_camera.y)
	camera.global_rotation.z = lerp_angle(camera.global_rotation.z, camera_position.global_rotation.z, delta * weight_camera.y)

	if resetting:
		global_rotation.x = lerp_angle(global_rotation.x, vector_reset.x, delta * 20)
		global_rotation.y = lerp_angle(global_rotation.y, vector_reset.y, delta * 20)
		if is_near_rotation(vector_reset) and resettimer.is_stopped():
			resettimer.start()

func initialize()->void:
	enabled = true

func view_reset(rotation : Vector3)->void:
	if not enabled:
		return
	if resettimer.is_stopped():
		vector_reset = rotation
		resetting = true
	
func is_resetting()->bool:
	return resetting

func move(rotation : Vector3, min : float = PITCH_MIN, max : float = PITCH_MAX)->void:
	if not enabled:
		return
	if not resetting:
		global_rotation = rotation
		global_rotation.x = clamp(global_rotation.x, deg_to_rad(min), deg_to_rad(max))
	
func move_add(rotation : Vector3, delta : float, min : float = PITCH_MIN, max : float = PITCH_MAX)->void:
	if not enabled:
		return
	if not resetting:
		global_rotation.x += rotation.x * delta * 100
		global_rotation.y += rotation.y * delta * 100
		global_rotation.x = clamp(global_rotation.x, deg_to_rad(min), deg_to_rad(max))
	
func is_near_rotation(rotation : Vector3)->bool:
	return global_rotation.distance_to(rotation) < 0.1
	
func get_rotation_view()->Vector2:
	return Vector2(global_rotation.y, global_rotation.x)
	
func get_camera_position()->Vector3:
	return camera_position.global_position
	
func get_camera_rotation()->Vector3:
	return camera_position.global_rotation

func calc_input_direction(input : Vector2)->Vector3:
	var vector_fwd : Vector3 = Vector3(0,0,1).rotated(Vector3.UP, camera_position.global_rotation.y)
	var vector_hor : Vector3 = Vector3(1,0,0).rotated(Vector3.UP, camera_position.global_rotation.y)
	return (vector_fwd * input.y + vector_hor * input.x)
	
