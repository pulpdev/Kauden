extends Controller
class_name ControllerActor

signal delay_sprint_finished
signal delay_dodge_finished
signal delay_attack_finished

@export var AttackDelay : Timer
@export var DodgeDelay : Timer
@export var SprintDelay : Timer
@export var Behavior : BehaviorRoot
@export var TargetPosition : Marker3D

var actor : Actor
var target : Actor

class ActorTarget:
	extends RefCounted
	var actor : Actor
	var location : Vector3
	var damage : int = 999

	func is_player()->bool:
		return actor.is_in_group("PLAYER")

func initialize(actor : Actor):
	self.actor = actor

	DodgeDelay.timeout.connect(on_DodgeDelay_timeout)
	AttackDelay.timeout.connect(on_AttackDelay_timeout)
	SprintDelay.timeout.connect(on_SprintDelay_timeout)

func is_sprinting()->bool:
	return not SprintDelay.is_stopped()

func on_DodgeDelay_timeout()->void:
	SprintDelay.start()
	delay_dodge_finished.emit()

func on_SprintDelay_timeout()->void:
	delay_sprint_finished.emit()

func on_AttackDelay_timeout()->void:
	SprintDelay.start()
	delay_attack_finished.emit()
