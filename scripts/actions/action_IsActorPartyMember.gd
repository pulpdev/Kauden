extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_gamemode_overworld():
		return FAILURE
	var gm : GameModeOverworld = get_gamemode()
	if not gm.Party.has_member(actor):
		return FAILURE
	return SUCCESS
