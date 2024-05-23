extends CharacterBody3D
class_name Actor

const MIN_DIST_TO_LOCATION : float = 1.1

@export var Controller : Controller
@export var ActionManager : ActionManager
@export var StateManager : StateManager
@export var data : ActorData
@export var Pivot : Pivot
@export var Eyes : Eyes

var friction : float = 0.5
var speed_turn : float = 0.1
var vector_move : Vector2

func _ready():
	if Controller:
		Controller.initialize(self)
		Controller.request_action_execute.connect(on_request_action_execute)
	if ActionManager:
		ActionManager.action_finished.connect(on_action_managager_action_finished)

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, vector_move.x, friction)
	velocity.z = move_toward(velocity.z, vector_move.y, friction)

	if is_on_floor():
		apply_gravity(0.0, delta)
	else:
		apply_gravity(GameScene.gravity, delta)

	move_and_slide()

func on_request_action_execute(action, params : Array)->void:
	match action:
		ActionRun:
			if StateManager.is_in_state("Free"):
				ActionManager.set_action("Run", params)
		ActionSprint:
			if StateManager.is_in_state("Free"):
				ActionManager.set_action("Sprint", params)
		ActionAnimate:
			if StateManager.is_in_state("Free"):
				ActionManager.set_action("Stand", [self])
				ActionManager.set_action("Animate", params)
				StateManager.set_state("ActionStatic")
				Input.start_joy_vibration(0, 0.5, 1.0, 0.1)
		ActionStand:
			if StateManager.is_in_state("Free"):
				ActionManager.set_action("Stand", params)

func on_action_managager_action_finished():
	StateManager.set_state("Free")

func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func apply_gravity(gravity : float, delta : float)->void:
	velocity.y -= GameScene.gravity * delta

func is_moving()->bool:
	return abs(velocity) > Vector3.ZERO
