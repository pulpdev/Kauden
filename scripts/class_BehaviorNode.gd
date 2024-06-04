@icon("res://assets/editor/behaviornode.svg")
extends Node
class_name BehaviorNode

enum {SUCCESS, FAILURE, RUNNING}

func tick(actor : Actor, blackboard)->int: return FAILURE

func is_controller_player(controller : Controller)->bool:
	return controller is ControllerPlayer
