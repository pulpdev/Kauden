extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not actor.Controller.AttackDelay.is_stopped():
		return SUCCESS
	return FAILURE
