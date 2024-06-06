extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	super(actor, blackboard)
	if not is_controller_player(actor.Controller):
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	if not pc.is_pressed_attack():
		return FAILURE
	return SUCCESS
