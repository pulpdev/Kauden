extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_gamemode_overworld():
		return FAILURE
	var gm : GameModeOverworld = get_gamemode()
	var p : Actor = gm.ActorManager.player
	blackboard.data_set("position_player", p.global_position)
	return SUCCESS
