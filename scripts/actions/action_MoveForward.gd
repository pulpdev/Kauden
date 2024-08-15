extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	actor.move(actor.Pivot.get_forward_direction(), 2)
	return SUCCESS
