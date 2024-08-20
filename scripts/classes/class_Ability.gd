extends Resource
class_name Ability

signal started
signal finished
signal wait_finished

@export var name : String

var running : bool
var wait_time_left: int
var wait_time_last : int
var waiting :  bool

var wait : int ## ur supposed to use this in execute() like "wait = await delay(1)"

class AbilityParams:
	extends RefCounted

	var ability_actor : Actor
	var ability_target : Actor

	func _init(actor : Actor, target : Actor = null) -> void:
		ability_actor = actor
		ability_target = target

func tick()->void:
	if running:
		if waiting:
			if wait_time_left > 0:
				wait_time_left -= Time.get_ticks_msec() - wait_time_last
			else:
				wait_finished.emit()

func execute(params : AbilityParams = null)->void:
	running = true
	waiting = false
	started.emit()

func delay(time : float)->int:
	wait_time_last = Time.get_ticks_msec()
	var new_wait_time_left : float = time * 60000
	wait_time_left = new_wait_time_left
	waiting = true
	await wait_finished
	waiting = false
	return 1

func finish()->void:
	running = false
	waiting = false
	finished.emit()
