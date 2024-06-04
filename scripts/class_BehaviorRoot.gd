@icon("res://assets/editor/behaviortree.svg")
extends Node
class_name BehaviorRoot

const BLACKBOARD : RefCounted = preload("res://scripts/modules/mod_Blackboard.gd")

@export var Actor : Actor
@export var enabled : bool = true

@onready var blackboard = BLACKBOARD.new()

func _physics_process(delta):
	if enabled:
		get_child(0).tick(self.Actor, blackboard)
