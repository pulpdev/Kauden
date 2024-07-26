@icon("res://assets/editor/behaviornode.svg")
extends Node
class_name BehaviorNode

enum {SUCCESS, FAILURE, RUNNING}

func tick(actor : Actor, blackboard : Blackboard)->int: return FAILURE

func is_controller_player(controller)->bool:
	return controller is ControllerPlayer

func is_controller_ai(controller)->bool:
	return controller is ControllerAI
	
func is_gamemode_overworld()->bool:
	if not get_scene() is GameScene:
		return false
	return get_tree().current_scene.GameMode is GameModeOverworld

func get_gamemode():
	return get_tree().current_scene.GameMode
	
func get_scene():
	return get_tree().current_scene
	
func get_player()->Actor:
	if not is_gamemode_overworld():
		return null
	var gm : GameModeOverworld = get_gamemode()
	return gm.ActorManager.player

func get_player_controller()->ControllerPlayer:
	return get_player().Controller
