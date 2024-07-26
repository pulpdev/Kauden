extends ActionLeaf

func tick(actor : Actor, blackboard : Blackboard)->int:
	var player : Actor = get_tree().get_first_node_in_group("PLAYER")
	var pc : ControllerPlayer = player.Controller
	var p : Vector3
	var gm : GameModeOverworld = get_tree().current_scene.GameMode
	
	if gm.Party.members[0] == actor:
		p = pc.get_party_positions()[0]
	elif gm.Party.members[1] == actor:
		p = pc.get_party_positions()[1]
		
	if actor.global_position.distance_to(p) < 2.0:
		return FAILURE
	if actor.global_position.distance_to(p) > 4.0:
		actor.move(actor.to_local(p).normalized(), actor.data.speed_run)
		actor.Pivot.Model.play_animation(actor.data.anim_run)
	elif actor.global_position.distance_to(p) > 2.0:
		if not actor.Pivot.Model.get_animation() == actor.data.anim_run:
			actor.move(actor.to_local(p).normalized(), actor.data.speed_walk)
			actor.Pivot.Model.play_animation(actor.data.anim_walk)
		else:
			actor.move(actor.to_local(p).normalized(), actor.data.speed_run)
			actor.Pivot.Model.play_animation(actor.data.anim_run)
	return RUNNING
	
	actor.move(actor.to_local(p).normalized(), actor.data.speed_run)
	actor.Pivot.Model.play_animation(actor.data.anim_run)
	return SUCCESS
