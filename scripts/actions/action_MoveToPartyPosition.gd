extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_gamemode_overworld():
		return FAILURE
	var gm : GameModeOverworld = get_gamemode()
	var player : Actor = gm.ActorManager.get_player()
	var i = blackboard.data_get("index_member")
	var position : Vector3 = gm.Party.positions_members[actor]
	if not actor.is_near_position(position):
		actor.move_to_position(position)
		return RUNNING
	return FAILURE
