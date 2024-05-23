extends Node
class_name ActionManager

signal action_finished

@export var action : Action
var actions : Dictionary

func _ready():
	for action in get_children():
		if action is Action:
			actions[action.name] = action
			action.finished.connect(on_action_finished)

func set_action(actionname : String, params : Array = []):
	var action : Action
	if actions.has(actionname):
		action = actions[actionname]
	else:
		Debug.error(self, "action key not found, '%s'" % actionname)
		return
	if self.action == action:
		return
	self.action = action
	self.action.execute(params)
	Debug.set_property("action", action)

func is_in_action(actionname : String)->bool:
	var action = actions[actionname]
	if action:
		return self.action == action
	Debug.error(self, "action key not found, '%s'" % actionname)
	return false

func on_action_finished():
	action = null
	action_finished.emit()
