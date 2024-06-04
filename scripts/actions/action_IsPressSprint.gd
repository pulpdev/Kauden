extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	if not is_controller_player(actor.Controller):
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	if not pc.is_pressing_sprint():
		return FAILURE
	return SUCCESS
