@icon("res://assets/editor/statemachine.svg")
extends Node
class_name StateMachine

var state : State
@export var enabled : bool
var states : Dictionary

class State:
	extends RefCounted

	var actor : Actor

	func initialize(actor : Actor)->void: self.actor = actor
	func can_enter()->bool:return true
	func can_exit()->bool:return true
	func on_enter()->void:pass
	func on_exit()->void:pass
	func tick()->void:pass

class StateFree:
	extends State
	
	func tick()->void:
		if not vector_input == Vector2.ZERO:
			actor.service_movement.move(springarm.calc_input_direction(vector_input), actor.data.speed_run)
			actor.pivot.model.play_animation(actor.data.anim_run)
		else:
			actor.pivot.model.play_animation(actor.data.anim_idle)

func initialize(controller : ControllerPlayer)->void:
	if not enabled:
		return

func set_state(statename : String)->void:
	if not enabled:
		return
	if states.has(statename):
		if state:
			state.exit()
		state = states[statename]
		state.enter()
	else:
		Debug.error(self, "state not found, '%s'" % statename)
	Debug.set_property("state", state)

func _process(delta):
	if not enabled:
		return

	Debug.set_property("state", state)

func _physics_process(delta):
	if not enabled:
		return
	if state:
		state.physics_process(delta)
