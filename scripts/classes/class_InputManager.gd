extends Node
class_name InputManager

enum ControlScheme {
	KEYBOARD_MOUSE = 0,
	GAMEPAD = 1
}

signal control_scheme_changed(scheme : ControlScheme)
signal vector_mouse_changed(vector : Vector2)
signal vector_joystick_changed(vector : Vector2)
signal action_pressed(action)
signal vector_look_changed(vector : Vector2)

var enabled : bool
var vector_input : Vector2
var vector_mouse : Vector2
var vector_joystick : Vector2
var sensitivity_mouse : float = 0.1
var sensitivity_joystick : float = 0.03

var control_scheme : ControlScheme = ControlScheme.KEYBOARD_MOUSE:
	set = set_control_scheme

func _input(event):
	if not enabled:
		return
	if event is InputEventMouseMotion:
		control_scheme = ControlScheme.KEYBOARD_MOUSE
		vector_mouse.x += deg_to_rad(-event.relative.x) * sensitivity_mouse
		vector_mouse.y += deg_to_rad(event.relative.y) * sensitivity_mouse
		vector_look_changed.emit(vector_mouse)

	if event is InputEventJoypadMotion:
		control_scheme = ControlScheme.GAMEPAD
		if event.axis == 2:
			vector_joystick.x = -event.axis_value * sensitivity_joystick
		if event.axis == 3:
			vector_joystick.y = event.axis_value * sensitivity_joystick
		vector_look_changed.emit(vector_joystick)

	if event is InputEventKey:
		control_scheme = ControlScheme.KEYBOARD_MOUSE

	if event is InputEventJoypadButton:
		control_scheme = ControlScheme.GAMEPAD

	if event.is_action_type():
		action_pressed.emit(event)

	vector_input = Input.get_vector("action_left", "action_right", "action_up", "action_down")

func set_control_scheme(scheme : ControlScheme)->void:
		if not control_scheme == scheme:
			control_scheme = scheme
			control_scheme_changed.emit(control_scheme)
