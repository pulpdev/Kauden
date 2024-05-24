extends Node

const DEBUG_PANEL : PackedScene = preload("res://scenes/DebugPanel.tscn")

@export var enabled : bool = true :
	set(x):
		if panel == null:
			enabled = false

@export var show : bool = true :
	set(b):
		show = b
		panel.PropList.visible = show

@export var paused : bool = false

var panel : CanvasLayer

func _ready():
	if enabled:
		panel = DEBUG_PANEL.instantiate()
		add_child(panel)

	set_property("FPS", Engine.get_frames_per_second())

func _process(delta):
	set_property("FPS", Engine.get_frames_per_second())

	if enabled:
		if Input.is_action_just_pressed("debug_show"):
			show = not show
		if Input.is_action_just_pressed("debug_quit"):
			get_tree().quit()
		if Input.is_action_just_pressed("debug_pause"):
			paused = not paused
	
	if paused:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT

func set_property(propname : String, value)->void:
	if not enabled:
		return
	var prop : Label = panel.PropList.find_child(propname, false, false)
	if not prop:
		prop = Label.new()
		prop.theme_type_variation = "DebugLabel"
		panel.PropList.add_child(prop)
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
