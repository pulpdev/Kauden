@icon("res://assets/editor/sequence.svg")
extends BehaviorNode
class_name CompositeSequence

func tick(actor : Actor, blackboard)->int:
	for c in get_children():
		var r = c.tick(actor, blackboard)
		if not r == SUCCESS:
			return r
	return SUCCESS
