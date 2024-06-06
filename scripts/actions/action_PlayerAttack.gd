extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	super(actor, blackboard)
	var vector_move : Vector3
	if not actor.Controller.AttackDelay.is_stopped():
		return FAILURE
	if actor.Controller is ControllerPlayer:
		var pc : ControllerPlayer = actor.Controller
		if pc.vector_input == Vector2.ZERO:
			vector_move = pc.SpringArm.get_yaw_direction()
		else:
			vector_move = actor.Pivot.get_forward_direction()
	else:
		vector_move = actor.Pivot.get_forward_direction()
	actor.move(vector_move, 15.0)
	actor.Pivot.Model.play_animation("player_attack_01", true)
	actor.Controller.AttackDelay.start()
	return RUNNING
