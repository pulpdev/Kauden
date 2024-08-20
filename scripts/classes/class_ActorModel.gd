extends Node3D
class_name ActorModel

const ANIM_BLEND_TIME : float = 1
const ANIM_DEFAULT : String = "_default"

@onready var animations : AnimationPlayer = $AnimationPlayer
@onready var skeleton : Skeleton3D = $Armature/Skeleton3D

func _ready():
	animations.animation_started.connect(_on_animation_player_animation_started)
	animations.animation_finished.connect(_on_animation_player_animation_finished)
	animations.playback_default_blend_time = ANIM_BLEND_TIME

func play_animation(anim : String, reset : bool = false)->void:
	if animations.has_animation(anim):
		if reset:
			animations.stop()
		animations.play(anim)
	else:
		Debug.error(self, "anim not found, '%s'" % anim)
		animations.play(ANIM_DEFAULT)

func get_animation()->String:
	return animations.current_animation

func _on_animation_player_animation_started(anim_name):
	match anim_name:
		"sprint":
			animations.speed_scale = 1.2
		"player_attack_01":
			animations.speed_scale = 2.0
		_:
			animations.speed_scale = 1.0

func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
