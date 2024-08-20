extends Controller
class_name ControllerActor

signal delay_sprint_finished
signal delay_dodge_finished
signal delay_attack_finished

@export var attack_delay : Timer
@export var dodge_delay : Timer
@export var sprint_delay : Timer
@export var behavior : BehaviorRoot
@export var target_manager : TargetManager
@export var target_area : Area3D

var actor : Actor

func initialize(actor : Actor):
	if not self.initialized:
		self.initialized = true
	else:
		return
	self.actor = actor

	dodge_delay.timeout.connect(on_dodge_delay_timeout)
	attack_delay.timeout.connect(on_attack_delay_timeout)
	sprint_delay.timeout.connect(on_sprint_delay_timeout)
	
	target_area.body_entered.connect(func(b):
		if b is Actor:
			target_manager.add_target(b))
	target_area.body_exited.connect(func(b):
		if b is Actor:
			target_manager.remove_target(b))

func is_sprinting()->bool:
	return not sprint_delay.is_stopped()

func on_dodge_delay_timeout()->void:
	sprint_delay.start()
	delay_dodge_finished.emit()

func on_sprint_delay_timeout()->void:
	delay_sprint_finished.emit()

func on_attack_delay_timeout()->void:
	sprint_delay.start()
	delay_attack_finished.emit()
