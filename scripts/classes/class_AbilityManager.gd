extends Node
class_name AbilityManager

@export var magic : Array[Ability]
@export var attack_combos : Array[Ability]


func _ready() -> void:
	return

func add_magic(magic : Ability)->void:
	self.magic.append(magic)
