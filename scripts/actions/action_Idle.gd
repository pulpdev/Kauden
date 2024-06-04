extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	actor.move(Vector3.ZERO, 0.0, actor.data.anim_idle)
	return SUCCESS
