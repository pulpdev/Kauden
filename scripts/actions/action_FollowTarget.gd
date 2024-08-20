extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	var position : Vector3 = blackboard.data_get("target").target_actor.global_position
	actor.pivot.model.play_animation(actor.data.anim_walk)
	actor.move(actor.to_local(position), actor.data.speed_walk)
	return SUCCESS
