extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_controller_player(actor.Controller):
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	var vector_move : Vector3 = pc.SpringArm.calc_input_direction(pc.vector_input)
	actor.move(vector_move, actor.data.speed_sprint, not pc.is_focusing)
	actor.Pivot.Model.play_animation(actor.data.anim_sprint)
	return SUCCESS
