@icon("res://assets/editor/behaviornode.svg")
extends Node
class_name BehaviorNode

enum {SUCCESS, FAILURE, RUNNING}

func tick(actor : Actor, blackboard : Blackboard)->int: return FAILURE

func is_controller_player(controller)->bool:
	return controller is ControllerPlayer

func is_controller_ai(controller)->bool:
	return controller is ControllerAI
