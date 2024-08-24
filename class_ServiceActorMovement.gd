extends RefCounted
class_name ServiceActorMovement

const FRICTION_DEFAULT : float = 20.0

var actor : Actor
var vector_move : Vector3
var vector_move_last : Vector3

func _init(actor : Actor)->void:
	self.actor = actor

func is_moving()->bool:
	return not actor.velocity == Vector3.ZERO

func move(vector : Vector3, speed : float, pivot_rotate : bool = true, friction : float = FRICTION_DEFAULT)->void:
	vector = vector.normalized()
	if pivot_rotate:
		actor.pivot.set_direction(vector)
	self.friction = friction
	self.speed = speed
	vector_move_last = vector * speed
	vector_move = vector_move_last

func tween_move(vector : Vector3, speed : float, duration : float, pivot_rotate : bool = true)->void:
	var t = actor.create_tween()
	vector = vector.normalized()
	if pivot_rotate:
		actor.pivot.set_direction(vector)
	t.tween_property(self, "vector_move", vector * speed, duration)
