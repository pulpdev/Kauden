extends Node
class_name AbilityManager

@export var magic : Array[Ability]
@export var attack_combos : Dictionary = {
	3 : Ability,
	4 : Ability,
	5 : Ability,
	6 : Ability
}

func _ready() -> void:
	add_magic(load("res://abstract/resources/abilities/attack_01.tres"))

func add_magic(magic : Ability)->void:
	self.magic.append(magic)
