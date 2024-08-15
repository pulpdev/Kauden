@icon("res://assets/editor/target.svg")
extends Node
class_name TargetManager

const DICT_TARGET : Dictionary = {
	"target_distance" : float(), #distance from self.actor to this target
	"target_damage" : int(), #damage dealt to self.actor by this target
	"target_time_known" : int() #time this target has been in the list
}

@export var actor : Actor

var targets : Dictionary
var target : Actor

func _physics_process(delta):
	for t in targets.keys():
		targets[t]["target_distance"] = self.actor.global_position.distance_to(t.global_position)
		targets[t]["target_time_known"] += 1

func target_add(actor : Actor)->void:
	if not targets.has(actor):
		var d : Dictionary = DICT_TARGET
		d.target_distance = actor.global_position.distance_to(self.actor.global_position)
		targets[actor] = d

func target_remove(actor : Actor)->void:
	targets.erase(actor)
	
func target_set(actor : Actor)->void:
	if targets.has(actor):
		target = actor

func target_find_distance_least()->Actor:
	var ts : Array[Actor] = targets.keys()
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Actor, b : Actor): 
			return targets[a]["target_distance"] < targets[b]["target_distance"])
	return ts.front()

func target_find_distance_most()->Actor:
	var ts : Array[Actor] = targets.keys()
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Actor, b : Actor): 
			return targets[a]["target_distance"] > targets[b]["target_distance"])
	return ts.front()

func target_find_damage_most()->Actor:
	var ts : Array[Actor] = targets.keys()
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Actor, b : Actor): 
			return targets[a]["target_damage"] > targets[b]["target_damage"])
	return ts.front()

func target_find_damage_least()->Actor:
	var ts : Array[Actor] = targets.keys()
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Actor, b : Actor): 
			return targets[a]["target_damage"] < targets[b]["target_damage"])
	return ts.front()

func target_find_known_least()->Actor:
	var ts : Array[Actor] = targets.keys()
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Actor, b : Actor): 
			return targets[a]["target_time_known"] < targets[b]["target_time_known"])
	return ts.front()

func target_find_known_most()->Actor:
	var ts : Array[Actor] = targets.keys()
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Actor, b : Actor): 
			return targets[a]["target_time_known"] > targets[b]["target_time_known"])
	return ts.front()

func target_set_damage(actor : Actor, damage : int)->void:
	if targets.has(actor):
		targets[actor]["target_damage"] = damage
