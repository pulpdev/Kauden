@icon("res://assets/editor/behaviortree.svg")
extends Node
class_name BehaviorRoot

@export var actor : Actor
@export var enabled : bool = true

@onready var blackboard = Blackboard.new()

var action : ActionLeaf

func _ready():
	if not get_tree().current_scene is GameScene\
	or actor == null:
		enabled = false

func _physics_process(delta):
	if enabled:
		get_child(0).tick(self.actor, blackboard)
