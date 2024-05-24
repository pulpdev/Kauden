extends Node
class_name ActionManager

signal action_finished

@export var action : Action
var actions : Dictionary

func _init():
	child_entered_tree.connect(add_action)

func set_action(actionname : String, params : Array = []):
	var action : Action
	if actions.has(actionname):
		action = actions[actionname]
	else:
		Debug.error(self, "action key not found, '%s'" % actionname)
		return
	self.action = action
	self.action.execute(params)
	Debug.set_property("action", self.action)
	
func add_action(action : Action)->void:
	actions[action.name] = action
	action.finished.connect(on_action_finished)

func is_in_action(actionname : String)->bool:
	var action = actions[actionname]
	if action:
		return self.action == action
	Debug.error(self, "action key not found, '%s'" % actionname)
	return false

func on_action_finished():
	action_finished.emit()
