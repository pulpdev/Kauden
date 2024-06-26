extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_controller_ai(actor.Controller):
		return FAILURE
	var c : ControllerAI = actor.Controller
	if c.target == null:
		return FAILURE
	return SUCCESS
