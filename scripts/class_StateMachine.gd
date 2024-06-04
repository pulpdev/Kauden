@icon("res://assets/editor/statemachine.svg")
extends Node
class_name StateMachine

@export var state : State
@export var enabled : bool
var states : Dictionary

func initialize(controller : ControllerPlayer)->void:
	if not enabled:
		return
	for c in get_children():
		if c is State:
			states[c.name] = c
			c.controller = controller
			c.transition.connect(set_state)
	if state:
		state.enter()

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
	if state == null:
		for s in get_children():
			if s.enter() == State.RUN:
				if not state == s:
					state = s
				break

	if state:
		if state.process(delta) == State.EXIT:
			state = null

	Debug.set_property("state", state)

func _physics_process(delta):
	if not enabled:
		return
	if state:
		state.physics_process(delta)
