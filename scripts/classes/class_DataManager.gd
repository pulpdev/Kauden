extends Node
class_name DataManager

var datas : Dictionary

func _ready():
	for data in get_children():
		datas[data.name] = data

func get_data(data : String)->void:pass
