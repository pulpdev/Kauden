extends Node3D
class_name Pivot

const MIN_DIST_TO_ANGLE : float = 0.01

@export var Model : ActorModel

func move(rot : float, delta : float, min_dist : float = MIN_DIST_TO_ANGLE)->void:
	global_rotation.y = lerp_angle(global_rotation.y, rot, delta)

func is_near_rotation(rot : float, min_dist : float = MIN_DIST_TO_ANGLE)->bool:
	return abs(global_rotation.y - rot) < min_dist

func get_direction()->Vector3:
	return global_transform.basis.z
