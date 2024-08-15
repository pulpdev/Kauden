@icon("res://assets/editor/state.svg")
extends Node
class_name State

enum {RUN, EXIT}

var controller : ControllerPlayer

signal transition(state : String)

func enter()->int:return EXIT
func exit()->void:pass
func process(delta:float)->int:return EXIT
func physics_process(delta:float)->void:pass
