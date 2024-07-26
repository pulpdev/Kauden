extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_gamemode_overworld():
		return FAILURE
	var gm : GameModeOverworld = get_gamemode()
	var i : int = gm.Party.get_member_index(actor)
	blackboard.data_set("index_member", i)
	return SUCCESS
