extends Node
class_name StateManager

@export var state : State
var states : Dictionary
var state_previous : State

func _init():
	child_entered_tree.connect(func(state): states[state.name] = state)

func set_state(statename : String, params : Object = null)->void:
	var state : State
	if states.has(statename):
		state = states[statename]
	else:
		Debug.error(self, "state not found, '%s'" % statename)
	if self.state:
		self.state.exit()
	self.state = state
	self.state.enter()
	Debug.set_property("state", state)

func get_state(state : String)->State:
	return states[state]
	
func is_in_state(statename : String)->bool:
	var state = states[statename]
	if state:
		return self.state == state
	Debug.error(self, "state not found, '%s'" % statename)
	return false

func _process(delta):
	if state:
		state.process(delta)

func _physics_process(delta):
	if state:
		state.physics_process(delta)
