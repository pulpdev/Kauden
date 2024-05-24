extends Node
class_name ParamManager

enum PARAMS {
	STRENGTH = 0,
	ENDURANCE = 1,
	DEXTERITY = 2,
	STAMINA = 3,
	POWER = 4,
	FARMING = 5,
	FISHING = 6,
	CRAFTING = 7,
	BUILDING = 8,
	LUMBERING = 9
}

var stats : Dictionary

func _on_child_entered_tree(node):
	if node is Parameter:
		stats[node.name] = node 

func add_modifier(stat : int, modifier : int)->void:
	get_child(stat).modifiers.push_back(modifier)

func set_stat(stat : int, value : int)->void:
	get_child(stat).base = value
