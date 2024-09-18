extends Node3D
class_name GameScene

static var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
static var vector_gravity : Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@export var GameMode : GameMode
@export var Background : Background

func _init():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _ready():
	if self.GameMode:
		self.GameMode.initialize(self)

func _physics_process(delta):
	var fps : int = Engine.get_frames_per_second()
	if fps > 60:
		if Engine.physics_ticks_per_second != fps:
			Engine.physics_ticks_per_second = fps
			Engine.max_physics_steps_per_frame = fps / 7.5
		else: return
	else:
		if Engine.physics_ticks_per_second != 60:
			Engine.physics_ticks_per_second = 60
			Engine.max_physics_steps_per_frame = 8
		else: return

func get_data()->Dictionary:
	var d : Dictionary = {}
	d["file"] = scene_file_path
	return d
