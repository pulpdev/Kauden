extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	var vector_move : Vector3
	if not actor.Controller.AttackDelay.is_stopped():
		return FAILURE
	vector_move = actor.Pivot.get_forward_direction()
	actor.move(vector_move, 20.0)
	actor.Pivot.Model.play_animation("player_attack_01", true)
	actor.Controller.AttackDelay.start()
	return RUNNING
