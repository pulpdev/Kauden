extends Node
class_name PlayerController

var player : Actor

func initialize(player : Actor)->void:
	self.player = player

	var im : InputManager = player.get_input_manager()
	if im:
		im.action_pressed.connect(on_action_pressed)
		im.control_scheme_changed.connect(on_control_scheme_changed)
		im.vector_look_changed.connect(on_vector_look_changed)

func on_action_pressed(action)->void:pass
func on_control_scheme_changed(scheme : InputManager.ControlScheme)->void:pass
func on_vector_look_changed(vector : Vector2)->void:pass
