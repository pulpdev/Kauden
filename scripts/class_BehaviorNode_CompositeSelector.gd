@icon("res://assets/editor/selector.svg")
extends BehaviorNode
class_name CompositeSelector

func tick(actor : Actor, blackboard)->int:
	for c in get_children():
		var r = c.tick(actor, blackboard)
		if not r == FAILURE:
			if c is ActionLeaf:
				actor.Controller.Behavior.action = c
				Debug.set_property("action", actor.Controller.Behavior.action)
			return r
	return FAILURE
