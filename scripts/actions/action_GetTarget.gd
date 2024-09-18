extends ActionLeaf

enum Faction {
	ANY, ##Find target of any faction.
	ALLY, ##Find target with the same faction of actor.
	ENEMY, ##Find target with the opposite faction of actor.
	NEUTRAL ##Find a target of Neutral faction.
	}
enum TYPES {
	ANY, ##Find any kind of target.
	NPC, ##Find any NPC.
	PLAYER ##Find any player.
	}
enum RANGES {
	RANDOM, ##Find any eligible target.
	DAMAGE_MOST, ##Find target that did the most damage to actor.
	DAMAGE_LEAST, ##Find target that did the least damage to actor.
	DISTANCE_LEAST, ##Find target that's closest to actor.
	DISTANCE_MOST, ##Find target that's furthest from actor.
	KNOWN_LEAST, ##Find target that's known the shortest.
	KNOWN_MOST ##Find target that's known the longest.
	}

@export var faction : Faction
@export var type : TYPES
@export var range : RANGES ##
@export var override_current : bool ##If able, will override current target with a new one.

func tick(actor : Actor, blackboard : Blackboard)->int:
	var target : TargetManager.Target
	var tm : TargetManager = actor.controller.target_manager
	var targets : Array[TargetManager.Target]

	if not override_current:
		if not blackboard.data_get("target") == null:
			if tm.has_target(blackboard.data_get("target").target_actor):
				return SUCCESS

	if tm.targets.size() == 0:
		target = null
		blackboard.data_set("target", target)
		return FAILURE

	targets = tm.targets.filter(
		func(t : TargetManager.Target):
			match faction:
				Faction.ANY:
					return true
				Faction.ALLY:
					return t.target_actor.faction == actor.faction
				Faction.ENEMY:
					return not t.target_actor.faction == actor.faction
				Faction.NEUTRAL:
					return t.target_actor.faction == Actor.Faction.NEUTRAL
			)
			
	if targets.size() == 0:
		target = null
		blackboard.data_set("target", target)
		return FAILURE
		
	targets = targets.filter(
		func(t : TargetManager.Target):
			match type:
				TYPES.ANY:
					return true
				TYPES.NPC:
					return not t.target_actor.is_in_group("PLAYER")
				TYPES.PLAYER:
					return t.target_actor.is_in_group("PLAYER")
			)

	if targets.size() == 0:
		target = null
		blackboard.data_set("target", target)
		return FAILURE

	match range:
		RANGES.RANDOM:
			target = targets.pick_random()
		RANGES.DAMAGE_MOST:
			target = tm.target_find_damage_most(targets)
		RANGES.DAMAGE_LEAST:
			target = tm.target_find_damage_least(targets)
		RANGES.DISTANCE_LEAST:
			target = tm.target_find_distance_least(targets)
		RANGES.DISTANCE_MOST:
			target = tm.target_find_distance_most(targets)
		RANGES.KNOWN_LEAST:
			target = tm.target_find_known_least(targets)
		RANGES.KNOWN_MOST:
			target = tm.target_find_known_most(targets)
			
	blackboard.data_set("target", target)
	return SUCCESS
