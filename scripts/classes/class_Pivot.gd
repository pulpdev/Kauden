extends Node3D
class_name Pivot

const MIN_DIST_TO_ANGLE : float = 0.01
const FRICTION_DEFAULT : float = 0.1

@export var Model : ActorModel

var direction_y : float
var can_rotate : bool
var friction : float = FRICTION_DEFAULT

func _process(delta):
	if can_rotate:
		move(direction_y, friction)
		if is_near_rotation(direction_y):
			can_rotate = false

func set_direction(direction : Vector3)->void:
	can_rotate = not direction == Vector3.ZERO
	direction_y = atan2(direction.x, direction.z)

func move(rotation : float, friction : float = FRICTION_DEFAULT)->void:
	self.friction = friction
	global_rotation.y = rotate_toward(global_rotation.y, rotation, self.friction)

func is_near_rotation(rot : float, min_dist : float = MIN_DIST_TO_ANGLE)->bool:
	return abs(global_rotation.y - rot) < min_dist

func get_forward_direction()->Vector3:
	return global_transform.basis.z
	
