@icon("res://assets/editor/inverter.svg")
extends BehaviorNode
class_name DecoratorInverter

func tick(actor : Actor, blackboard)->int:
	for c in get_children():
		var r : int = c.tick(actor, blackboard)
		if r == SUCCESS:
			return FAILURE
		if r == FAILURE:
			return SUCCESS
	return RUNNING
