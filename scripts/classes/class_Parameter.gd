extends Node
class_name Parameter

const VALUE_MAX : int = 100

signal base_changed(b)
signal value_changed(v)

@export_range(0, VALUE_MAX) var base : int:
	set(x):
		base = clamp(x, 0, VALUE_MAX)
		base_changed.emit(base)

var value : int:
	set(x):
		value = clamp(x, 0, VALUE_MAX)
		value_changed.emit(value)
		
	get:
		return base + get_modifier_bonus()

var modifiers : Array[int]

func get_modifier_bonus()->int:
	var bonus : int
	for modifier in modifiers:
		bonus += modifier
	return bonus
