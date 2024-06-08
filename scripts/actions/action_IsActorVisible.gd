extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	if not is_controller_ai(actor.Controller):
		return FAILURE
	var c : ControllerAI = actor.Controller
	if not c.VisionArea.get_overlapping_bodies():
		return FAILURE
	return SUCCESS
