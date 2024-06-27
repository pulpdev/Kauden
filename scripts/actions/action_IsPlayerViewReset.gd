extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_controller_player(actor.Controller):
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	if pc.SpringArm.is_yaw_near_vector(actor.Pivot.global_rotation):
		return SUCCESS
	return FAILURE
