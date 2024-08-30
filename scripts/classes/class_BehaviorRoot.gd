@icon("res://assets/editor/behaviortree.svg")
extends Node
class_name BehaviorRoot

var actor : Actor
var enabled : bool

@onready var blackboard = Blackboard.new()

func _physics_process(delta):
	if enabled:
		get_child(0).tick(self.actor, blackboard)

func initialize(actor : Actor)->void:
	if not get_tree().current_scene is GameScene:
		enabled = false
	else:
		self.actor = actor
		enabled = true
