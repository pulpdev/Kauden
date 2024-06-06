extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	super(actor, blackboard)
	if not is_controller_player(actor.Controller):
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	if not pc.vector_input == Vector2.ZERO:
		return SUCCESS
	else:
		return FAILURE
