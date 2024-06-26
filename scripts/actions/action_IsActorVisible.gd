extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_controller_ai(actor.Controller):
		return FAILURE
	var c : ControllerAI = actor.Controller
	if not c.get_visible_actors():
		return FAILURE
	return SUCCESS
