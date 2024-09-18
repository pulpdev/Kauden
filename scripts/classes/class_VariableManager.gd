extends Node
class_name VariableManager

func get_variables()->Array[Variable]:
	return get_children() as Array[Variable]
