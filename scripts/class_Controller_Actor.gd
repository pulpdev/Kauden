extends Controller
class_name ControllerActor

@export var AttackDelay : Timer
@export var DodgeDelay : Timer
@export var Behavior : BehaviorRoot
@export var TargetPosition : Marker3D

var actor : Actor

class ActorTarget:
	extends RefCounted
	var actor : Actor
	var location : Vector3
	var damage : int = 999
	
	func is_player()->bool:
		return actor.is_in_group("PLAYER")

func initialize(actor : Actor):
	self.actor = actor

func attack()->void:
	pass
