extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	super(actor, blackboard)
	if not actor.Controller.AttackDelay.is_stopped():
		return SUCCESS
	return FAILURE
