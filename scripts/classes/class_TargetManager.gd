@icon("res://assets/editor/target.svg")
extends Node
class_name TargetManager

@export var actor : Actor

var targets : Array[Target]
var target : Target

class Target:
	extends RefCounted
	
	func _init(actor : Actor):
		target_actor = actor
	
	var target_actor : Actor
	var target_distance : float
	var target_time_known : int
	var target_damage : int

func _physics_process(delta):
	for t in targets:
		t.target_distance = actor.global_position.distance_to(t.target_actor.global_position)
		t.target_time_known += 1

func add_target(actor : Actor)->void:
	if not has_target(actor):
		var t : Target = Target.new(actor)
		t.target_distance = actor.global_position.distance_to(self.actor.global_position)
		targets.append(t)

func has_target(actor : Actor)->bool:
	for t in targets:
		if t.target_actor == actor:
			return true
	return false
	
func get_target(actor : Actor)->Target:
	for t in targets:
		if t.target_actor == actor:
			return t
	return null

func remove_target(actor : Actor)->void:
	for t in range(targets.size() - 1):
		if targets[t].target_actor == actor:
			targets.pop_at(t)
	
func set_target(actor : Actor)->void:
	var t : Target = get_target(actor)
	if t:
		target = t

func get_player_target()->Target:
	for t in targets:
		if t.target_actor.is_in_group("PLAYER"):
			return t
	return null

func target_find_distance_least()->Target:
	var ts : Array[Target] = targets.duplicate(true)
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Target, b : Target): return a.target_distance < b.target_distance)
	return ts.front()

func target_find_distance_most()->Target:
	var ts : Array[Target] = targets.duplicate(true)
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Target, b : Target): return a.target_distance > b.target_distance)
	return ts.front()

func target_find_damage_most()->Target:
	var ts : Array[Target] = targets.duplicate(true)
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Target, b : Target): return a.target_damage > b.target_damage)
	return ts.front()

func target_find_damage_least()->Target:
	var ts : Array[Target] = targets.duplicate(true)
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Target, b : Target): return a.target_damage < b.target_damage)
	return ts.front()

func target_find_known_least()->Target:
	var ts : Array[Target] = targets.duplicate(true)
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Target, b : Target): return a.target_time_known < b.target_time_known)
	return ts.front()

func target_find_known_most()->Target:
	var ts : Array[Target] = targets.duplicate(true)
	if ts.size() == 0:
		return null
	ts.sort_custom(
		func(a : Target, b : Target): return a.target_time_known > b.target_time_known)
	return ts.front()

func target_set_damage(target : Target, damage : int)->void:
	target.target_damage = damage
