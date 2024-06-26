extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if actor.Controller.DodgeDelay.is_stopped():
		return FAILURE
	return SUCCESS
