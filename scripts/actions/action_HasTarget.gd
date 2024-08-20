extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	if not blackboard.data_get("target") == null:
		return SUCCESS
	return FAILURE
