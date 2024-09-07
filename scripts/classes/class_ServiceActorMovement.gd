extends Node
class_name ServiceActorMovement

var actor : Actor

#func _init(actor : Actor) -> void:
	#self.actor = actor
	
func i(actor : Actor)->void:
	self.actor = actor

func move(vector : Vector3, speed : float)->void:
	vector = vector.normalized() * speed
	actor.velocity.x = vector.x
	if not vector.y == 0.0:
		actor.velocity.y = vector.y
	actor.velocity.z = vector.z

func tween_move(
	vector : Vector3,
	speed : float, 
	length : float,
	ease : Tween.EaseType = Tween.EASE_IN,
	trans : Tween.TransitionType = Tween.TRANS_SINE)->void:
		actor.velocity_tween = create_tween()
		vector = actor._pivot.get_forward_direction()
		vector = vector.normalized() * speed
		actor.velocity_tween.tween_property(actor, "velocity", vector, length)

func get_model_direction()->Vector3:
	return actor._pivot.get_forward_direction()
