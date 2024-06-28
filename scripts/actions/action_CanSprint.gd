extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if actor.Controller.SprintDelay.is_stopped():
		return SUCCESS
	return FAILURE
