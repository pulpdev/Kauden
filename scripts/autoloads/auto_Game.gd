extends Node

class SaveData:
	extends Resource

	var filepath : String
	var data : Dictionary

	func _init(filepath : String, data : Dictionary) -> void:
		self.filepath = filepath
		self.data = data
