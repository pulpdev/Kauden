extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not actor.Controller.DodgeDelay.is_stopped():
		return FAILURE
	if not actor.Controller is ControllerPlayer:
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	var vector : Vector3
	if pc.is_focusing:
		vector = pc.SpringArm.calc_input_direction(pc.vector_input)
	else:
		vector = actor.Pivot.get_forward_direction()
	actor.move(vector, 20.0, not pc.is_focusing, 0.05)
	pc.DodgeDelay.start()
	return SUCCESS
