extends Node
class_name Variable

@export var persists : bool
@export_range(0, 999999) var value : int : set = set_value

func set_value(v : int)->void:
	v = clamp(v, 0, 999999)
	value = v
