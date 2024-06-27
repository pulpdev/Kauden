@icon("res://assets/editor/failer.svg")
extends BehaviorNode
class_name DecoratorFailer

func tick(actor : Actor, blackboard : Blackboard)->int:
	for c in get_children():
		var r : int = c.tick(actor, blackboard)
		if not r == RUNNING:
			return FAILURE
	return RUNNING
