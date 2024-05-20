extends Node

@export var enabled : bool = true :
	set(b):
		enabled = b
		PropList.visible = enabled

@onready var PropList : VBoxContainer = %PropList

func set_property(propname : String, value)->void:
	if not enabled:
		return
	var prop : Label = PropList.find_child(propname, false, false)
	if not prop:
		prop = Label.new()
		prop.theme_type_variation = "DebugLabel"
		PropList.add_child(prop)
		prop.name = propname
	prop.text = "%s: %s" % [propname, str(value)]

func _process(delta):
	set_property("FPS", Engine.get_frames_per_second())
