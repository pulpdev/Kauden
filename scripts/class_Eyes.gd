extends Node3D
class_name Eyes

func get_look_vector_direction(position : Vector3)->Vector3:
	look_at(position, Vector3.UP, true)
	return global_transform.basis.z
	
func get_look_vector_rotation(position : Vector3)->Vector3:
	look_at(position, Vector3.UP, true)
	return global_rotation
