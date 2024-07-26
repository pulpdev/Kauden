extends ActionLeaf

@export var distance : float = 0.0

func tick(actor : Actor, blackboard : Blackboard)->int:
	for b in actor.Controller.AudialArea.get_overlapping_bodies():
		if b.is_in_group("PLAYER"):
			if actor.is_near_position(b.global_position, distance):
				return SUCCESS
	return FAILURE
