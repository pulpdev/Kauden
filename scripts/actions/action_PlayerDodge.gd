extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	var vector_move : Vector3
	if not actor.Controller.DodgeDelay.is_stopped():
		return FAILURE
	if not actor.Controller is ControllerPlayer:
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	var vector : Vector3 = pc.SpringArm.calc_input_direction(pc.vector_input)
	actor.move(vector, 20.0, not pc.is_focusing, 0.05)
	pc.DodgeDelay.start()
	return SUCCESS
