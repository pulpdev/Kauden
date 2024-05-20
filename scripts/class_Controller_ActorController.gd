extends Controller
class_name ActorController

signal destination_reached(dest : Vector3)

var actor : Actor
var destination : Vector3
var command_move : MoveCommand = MoveCommand.new()

func _init(actor : Actor):
	self.actor = actor

func _physics_process(delta):
	if not destination == Vector3.ZERO:
		if not actor.near_position(destination):
			var vector : Vector3 = (actor.to_local(destination)).normalized()
			command_move.execute(actor, MoveCommand.Params.new(vector, actor.speed_move))
		else:
			destination_reached.emit(destination)
			destination = Vector3.ZERO
