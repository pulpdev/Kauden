extends Node
class_name ParamManager

enum {
	ATTACK = 0,
	DEFENSE = 1,
	SKILL = 3,
	MAGIC = 4,
}

var stats : Dictionary

func _on_child_entered_tree(node):
	if node is Parameter:
		stats[node.name] = node 

func add_modifier(stat : int, modifier : int)->void:
	get_child(stat).modifiers.push_back(modifier)

func set_stat(stat : int, value : int)->void:
	get_child(stat).base = value
