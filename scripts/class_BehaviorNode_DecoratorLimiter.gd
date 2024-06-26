@icon("res://assets/editor/limiter.svg")
extends BehaviorNode
class_name DecoratorLimiter

@export var limit : int

@onready var key = "limiter_%s" % get_instance_id()

func tick(actor : Actor, blackboard : Blackboard)->int:
	var count : int = blackboard.get_data(key)
	if count == null:
		count = 0
	if count <= limit:
		blackboard.set_data(key, count + 1)
		return get_child(0).tick(actor, blackboard)
	else:
		return FAILURE
