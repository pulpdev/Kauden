extends ActionLeaf

@export var distance : float = 0.0

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not is_gamemode_overworld():
		return FAILURE
	var i : int = blackboard.data_get("index_member")
	var player : Actor = get_player()
	var p : Vector3 = get_gamemode().Party.positions_members[actor]
	if actor.is_near_position(p, distance):
		return SUCCESS
	return FAILURE
