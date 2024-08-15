extends Node3D
class_name ActorModel

const ANIM_BLEND_TIME : float = 1
const ANIM_DEFAULT : String = "_default"

@onready var Animations : AnimationPlayer = $AnimationPlayer
@onready var Skeleton : Skeleton3D = $Armature/Skeleton3D

func _ready():
	Animations.animation_started.connect(_on_animation_player_animation_started)
	Animations.animation_finished.connect(_on_animation_player_animation_finished)
	Animations.playback_default_blend_time = ANIM_BLEND_TIME

func play_animation(anim : String, reset : bool = false)->void:
	if Animations.has_animation(anim):
		if reset:
			Animations.stop()
		Animations.play(anim)
	else:
		Debug.error(self, "anim not found, '%s'" % anim)
		Animations.play(ANIM_DEFAULT)

func get_animation()->String:
	return Animations.current_animation

func _on_animation_player_animation_started(anim_name):
	match anim_name:
		"sprint":
			Animations.speed_scale = 1.2
		"player_attack_01":
			Animations.speed_scale = 2.0
		_:
			Animations.speed_scale = 1.0

func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
