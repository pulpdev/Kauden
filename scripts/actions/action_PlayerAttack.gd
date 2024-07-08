extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not actor.Controller.AttackDelay.is_stopped():
		return FAILURE
	if not actor.Controller is ControllerPlayer:
		return FAILURE
	var pc : ControllerPlayer = actor.Controller
	if not pc.vector_input == Vector2.ZERO:
		var vector_move : Vector3 = actor.Pivot.get_forward_direction()
		actor.move(vector_move, 0.0)
	actor.Pivot.Model.play_animation("player_attack_01", true)
	actor.Controller.AttackDelay.start()
	return RUNNING
