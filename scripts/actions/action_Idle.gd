extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	actor.Pivot.Model.play_animation(actor.data.anim_idle)
	return SUCCESS
