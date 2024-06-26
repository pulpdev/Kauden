extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_controller_ai(actor.Controller):
		return FAILURE
	var c : ControllerAI = actor.Controller
	
	if not c.target == null:
		return SUCCESS

	if c.get_visible_actors().size() == 0:
		return FAILURE

	var target : Actor
	for t in c.get_visible_actors():
		if c.can_target_actor(t):
			target = t
			break
			
	if target == null:
		return FAILURE

	c.target = target

	return SUCCESS
