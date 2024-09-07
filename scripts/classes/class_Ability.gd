extends Node
class_name Ability

signal started
signal finished
signal wait_finished

@export_range(0.1, 1000) var length_base : float = 0.1

@onready var timer : Timer = %Timer

var sequence : int

class AbilityParams:
	extends RefCounted

	var ability_actor : Actor
	var ability_targets : Array[TargetManager.Target]

	func _init(actor : Actor, targets : Array[TargetManager.Target] = []) -> void:
		ability_actor = actor
		ability_targets = targets

func _ready() -> void:
	timer.autostart = false
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS

func execute(params : AbilityParams = null)->void:pass
