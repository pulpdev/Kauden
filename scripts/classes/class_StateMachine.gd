@icon("res://assets/editor/statemachine.svg")
extends Node
class_name StateMachine

var state : State
var states : Dictionary = {
	StateFree : StateFree.new(),
	StateAttack : StateAttack.new()
}
class State:
	extends RefCounted

	var actor : Actor
	var statemachine : StateMachine

	func initialize(actor : Actor)->void: self.actor = actor
	func can_enter()->bool:return true
	func can_exit()->bool:return true
	func on_enter()->void:pass
	func on_exit()->void:pass
	func tick(delta : float)->void:pass

class StateFree:
	extends State

	func can_enter()->bool:
		if not actor._attack_timer.is_stopped():
			return false
		return true

	func tick(delta : float)->void:
		var im : InputManager = actor.get_input_manager()
		var sa : SpringArm = actor.get_springarm()
		if not im.vector_input == Vector2.ZERO:
			actor.service_movement.move(sa.calc_input_direction(im.vector_input), actor.data.speed_run)
			actor.service_animation.play("run-up-01")
		else:
			actor.service_animation.play("idle-01")


class StateAttack:
	extends State

	func can_enter()->bool:
		if not Input.is_action_just_pressed("action_attack"):
			return false
		if not actor._attack_timer.is_stopped():
			return false
		return true
		
	func can_exit()->bool:
		if not actor._attack_timer.is_stopped():
			return false
		return true
		
	func on_enter()->void:
		var p : Ability.AbilityParams = Ability.AbilityParams.new(actor)
		var a : Ability = actor._ability_manager.attack_combos[0]
		a.execute(p)
		actor._attack_timer.wait_time = a.length_base
		actor._attack_timer.start()
		
	func tick(delta : float)->void:
		return
		if actor._attack_timer.is_stopped():
			statemachine.try_state(StateFree)
		
func initialize(actor : Actor):
	for s in states.values():
		s.initialize(actor)
		s.statemachine = self

func get_state(state):
	return states[state]

func try_state(state)->bool:
	var s
	if states.has(state):
		s = get_state(state)
	else:
		return false
	if s.can_enter():
		if self.state:
			if self.state.can_exit():
				self.state.on_exit()
			else:
				return false
		self.state = s
		self.state.on_enter()
		Debug.set_property("state", state)
	else:
		return false

	return true

func set_state(statename : String)->void:
	if states.has(statename):
		if state:
			state.exit()
		state = states[statename]
		state.enter()
	else:
		Debug.error(self, "state not found, '%s'" % statename)
	Debug.set_property("state", state)

func _physics_process(delta):
	if state:
		state.tick(delta)
