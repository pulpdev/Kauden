extends ActorCommand
class_name MoveCommand

class Params:
	var vector : Vector3
	var speed : float

	func _init(vector : Vector3, speed : float)->void:
		self.vector = vector
		self.speed = speed

func execute(actor : Actor, params : Object = null)->void:
	if params is Params:
		actor.move(params.vector, params.speed)
