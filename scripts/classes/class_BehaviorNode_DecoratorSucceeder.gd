@icon("res://assets/editor/succeeder.svg")
extends BehaviorNode
class_name DecoratorSucceeder

func tick(actor : Actor, blackboard : Blackboard)->int:
	for c in get_children():
		var r : int = c.tick(actor, blackboard)
		if not r == RUNNING:
			return SUCCESS
	return RUNNING
