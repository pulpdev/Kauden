extends RefCounted
class_name Blackboard

const NAME_DEFAULT = "default"

var data : Dictionary = {}

func set_data(key : String, value, name : String = NAME_DEFAULT)->void:
	if not data.has(name):
		data[name] = {}
	else:
		data[name][key] = value
		
func get_data(key : String, default = null, name : String = NAME_DEFAULT)->Variant:
	if has_data(key, name):
		return data[name].get(key, default)
	return default
	
func has_data(key : String, name : String = NAME_DEFAULT)->bool:
	return data.has(name) and data[name].has(key) and data[name][key] != null
	
func erase_data(key : String, name : String = NAME_DEFAULT)->void:
	if data.has(name):
		data[name][key] = null
