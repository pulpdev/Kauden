extends Node3D
class_name Eyes

func get_look_vector(position : Vector3)->Vector3:
	look_at(position, Vector3.UP)
	return global_rotation
