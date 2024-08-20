extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	var t : TargetManager.Target = actor.controller.target_manager.get_player_target()
	if t:
		blackboard.data_set("target", t.target_actor)
	return SUCCESS
