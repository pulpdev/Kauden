extends Node3D
class_name ActorManager

signal actor_created(actor : Actor)
signal actor_added(actor : Actor)
signal actor_removed(actor : Actor)
signal actor_freeing(actor : Actor)

var player : Actor
var actors : Array[Actor]

func _ready():
	for a in get_children():
		if a is Actor:
			if not actors.has(a):
				actors.append(a)
			if player == null:
				if a.is_in_group("PLAYER"):
					player = a

func actor_create(scene : PackedScene)->Actor:
	var a : Actor = scene.instantiate()
	if not actors.has(a):
		actors.append(a)
	actor_created.emit(a)
	return a

func actor_add(actor : Actor, position : Vector3 = Vector3.ZERO, rotation : Vector3 = Vector3.ZERO)->void:
	if actors.has(actor):
		add_child(actor)
		actor.global_position = position
		actor.global_rotation = rotation
		actor_added.emit(actor)

func actor_remove(actor : Actor)->void:
	if actors.has(actor):
		remove_child(actor)
		actor_removed.emit(actor)

func actor_free(actor : Actor)->void:
	if actors.has(actor):
		actor.queue_free()
		actors.pop_at(actors.find(actor))
		actor_freeing.emit(actor)

func is_actor_inside(actor : Actor)->void:
	if actors.has(actor):
		return actor.is_inside_tree()

func get_player()->Actor:
	return player
