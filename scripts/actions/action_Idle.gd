extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	actor.pivot.model.play_animation(actor.data.anim_idle)
	return SUCCESS
