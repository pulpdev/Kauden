extends Node
class_name Variable

@export_range(0, 999999) var value : int : set = set_value

func set_value(v : int)->void:
	v = clamp(v, 0, 999999)
	value = v

func on_save_data()->Game.SaveData:
	var d : Dictionary
	d["value"] = value
	var s : Game.SaveData = Game.SaveData.new(
		scene_file_path,
		d
	)
	return s

func on_load_data(data : Dictionary)->void:
	value = data["value"]
