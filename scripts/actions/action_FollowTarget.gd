extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_controller_ai(actor.Controller):
		return FAILURE
	var c : ControllerAI = actor.Controller

	if c.target == null:
		return FAILURE

	var p : Vector3 = actor.Controller.target.global_position
	if actor.global_position.distance_to(p) < 2.0:
		return FAILURE
	if actor.global_position.distance_to(p) > 4.0:
		actor.move(actor.to_local(p).normalized(), actor.data.speed_run)
		actor.Pivot.Model.play_animation(actor.data.anim_run)
	elif actor.global_position.distance_to(p) > 2.0:
		if not actor.Pivot.Model.get_animation() == actor.data.anim_run:
			actor.move(actor.to_local(p).normalized(), actor.data.speed_walk)
			actor.Pivot.Model.play_animation(actor.data.anim_walk)
		else:
			actor.move(actor.to_local(p).normalized(), actor.data.speed_run)
			actor.Pivot.Model.play_animation(actor.data.anim_run)
	return RUNNING
