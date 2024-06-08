extends ActionLeaf

func tick(actor : Actor, blackboard)->int:
	if not actor.Controller.VisionArea.get_overlapping_bodies():
		return FAILURE
	var p : Vector3 = actor.Controller.VisionArea.get_overlapping_bodies()[0].global_position
	actor.move(actor.to_local(p).normalized(), actor.data.speed_run)
	actor.Pivot.Model.play_animation(actor.data.anim_run)
	return RUNNING
