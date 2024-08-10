extends Node

@export var caller : Node
@export var callable : String
@export var arguments : Array

func _on_pressed():
	if caller:
		if caller.get(callable):
			caller.callv(callable, arguments)
