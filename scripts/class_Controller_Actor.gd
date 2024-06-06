extends Controller
class_name ControllerActor

@export var AttackDelay : Timer
@export var Behavior : BehaviorRoot

var player : Actor

func initialize(actor : Actor):
	self.actor = actor

func attack()->void:
	pass
