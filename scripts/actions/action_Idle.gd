extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	#actor.move(Vector3.ZERO, 0.0)
	actor.Pivot.Model.play_animation(actor.data.anim_idle)
	return SUCCESS
