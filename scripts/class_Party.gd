@icon("res://assets/editor/party.svg")
extends Node
class_name Party

const MEMBERS_MAX : int = 2

signal member_added(actor : Actor)
signal member_removed(actor : Actor)

@export var roster : PackedSceneList
@export var members : Array[Actor]

var actors : Array[Actor]
var positions_members : Dictionary

func get_roster()->Array[PackedScene]:
	return roster.scenes
	
func set_actor_list(list : Array[Actor])->void:
	actors = list

func get_members_size()->int:
	return members.size()

func member_add(actor : Actor, index : int = -1)->void:
	if is_full():
		return
	if not is_actor_listed(actor):
		return
	if has_member(actor):
		return
	var a : Actor = actors[actors.find(actor)]
	if index > -1:
		var ractor : Actor = get_member(index)
		member_remove_at_index(index)
		members.insert(index, actor)
		member_removed.emit(ractor)
	else:
		members.append(actor)
	member_added.emit(actor)
	pop_null_member_indices()

func is_actor_listed(actor : Actor)->bool:
	return actors.has(actor)

func get_member_index(actor : Actor)->int:
	return members.find(actor)

func pop_null_member_indices()->void:
	members.filter(func(i): return i != null)

func member_remove_at_ref(actor : Actor)->void:
	members.remove_at(members.find(actor))

func member_remove_at_index(index : int)->void:
	members.remove_at(index)

func is_full()->bool:
	return members.size() >= MEMBERS_MAX

func get_member(index : int)->Actor:
	return members[index]
	
func get_actor(index : int)->Actor:
	return actors[index]

func has_member(actor : Actor)->bool:
	return members.has(actor)

func get_members()->Array[Actor]:
	return members
	
func set_member_positions(positions : Array[Vector3])->void:
	positions_members.clear()
	for m in members:
		positions.sort_custom(func(a,b): 
			m.global_position.distance_to(a) < m.global_position.distance_to(b))
		var position : Vector3
		if not positions_members.find_key(positions.front()):
			position = positions.front()
		else:
			position = positions.back()
		positions_members[m] = position
		
