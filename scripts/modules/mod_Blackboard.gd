extends RefCounted
class_name Blackboard

const NAME_DEFAULT = "default"

var data : Dictionary = {}

func data_set(key : String, value, name : String = NAME_DEFAULT)->void:
	if not data.has(name):
		data[name] = {}
	data[name][key] = value
		
func data_get(key : String, default = null, name : String = NAME_DEFAULT)->Variant:
	if data_has(key, name):
		return data[name].get(key, default)
	return default
	
func data_has(key : String, name : String = NAME_DEFAULT)->bool:
	return data.has(name) and data[name].has(key) and data[name][key] != null
	
func data_erase(key : String, name : String = NAME_DEFAULT)->void:
	if data.has(name):
		data[name][key] = null
