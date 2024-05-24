extends Node
class_name State

@export var transitions : Array[State]

var states : Dictionary

func _init():
	child_entered_tree.connect(func(state): states[state.name] = state)

func enter(params : Object = null)->void:pass
func exit()->void:pass
func process(delta:float)->void:pass
func physics_process(delta:float)->void:pass
