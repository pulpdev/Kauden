@icon("res://assets/editor/selector.svg")
extends BehaviorNode
class_name CompositeSelector

func tick(actor : Actor, blackboard : Blackboard)->int:
	for c in get_children():
		var r = c.tick(actor, blackboard)
		if not r == FAILURE:
			return r
	return FAILURE
