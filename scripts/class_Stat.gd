extends Node
class_name Stat

const MAX_FLOAT : float = 100.0
const MAX_INT : int = 2147483647

signal base_changed(b)
signal value_changed(v)

@export var is_float : bool

@export var base : float:
	set(x):
		if is_float:
			base = clamp(x, 0.0,MAX_FLOAT)
		else:
			base = clamp(x, 0.0, MAX_INT)
		base_changed.emit(base)
		value_changed.emit(value)
	get:
		if is_float:
			return base
		return int(base)

var value : float:
	get:
		var value = base
		for modifier in modifiers:
			if typeof(modifier) == TYPE_FLOAT:
				value *= 1.0 + modifier
		for modifier in modifiers:
			if typeof(modifier) == TYPE_INT:
				value += modifier
		if is_float:
			return int(value)
		return snapped(float(value), 0.01)

var modifiers : Array[int]
