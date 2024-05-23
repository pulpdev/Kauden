extends Node

@export var enabled : bool = true :
	set(b):
		enabled = b
		PropList.visible = enabled

@onready var PropList : VBoxContainer = %PropList

func _ready():
	set_property("FPS", Engine.get_frames_per_second())

func _process(delta):
	set_property("FPS", Engine.get_frames_per_second())
	if Input.is_action_just_pressed("debug_enable"):
		enabled = not enabled
	if Input.is_action_just_pressed("debug_quit"):
		get_tree().quit()

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

func out(sender : Object, txt : String)->void:
	if enabled:
		print(sender, ": ", txt)

func warn(sender : Object, txt : String)->void:
	if enabled:
		push_warning(sender, ": ", txt)

func error(sender : Object, txt : String)->void:
	if enabled:
		push_error(sender, ": ", txt)
