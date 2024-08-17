@icon("res://assets/editor/cooldown.svg")
extends BehaviorNode
class_name DecoratorCooldown

@export_range(0.1, 1000.0) var cooldown : float

@onready var key = "limiter_%s" % get_instance_id()

func tick(actor : Actor, blackboard : Blackboard)->int:
	var time : float = blackboard.data_get(key, cooldown)
	if time > 0.0:
		time -= get_physics_process_delta_time()
		blackboard.data_set(key, time)
		return FAILURE
	else:
		time = cooldown
		blackboard.data_set(key, time)
		var r : int = get_child(0).tick(actor, blackboard)
		return get_child(0).tick(actor, blackboard)
