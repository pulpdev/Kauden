@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

enum FACTIONS {GOOD, EVIL, NEUTRAL}

const MIN_DIST_TO_LOCATION : float = 0.3
const FRICTION_DEFAULT : float = 20.0

@export var data : ActorData
@export var faction : FACTIONS = FACTIONS.NEUTRAL

@export_category("Components")
@export var controller : ControllerActor
@export var _pivot : Pivot
@export var _eyes : Eyes
@export var _target_position : Marker3D
@export var _behavior : BehaviorRoot
@export var _springarm : SpringArm
@export var _statemachine : StateMachine

@export_category("Timers")
@export var _attack_timer : Timer

@export_category("Managers")
@export var _ability_manager : AbilityManager
@export var _target_manager : TargetManager
@export var _stats_manager : StatManager
@export var _input_manager : InputManager

@export_category("Areas")
@export var area_target : Area3D

@export_category("Rays")
@export var _ray_target : RayCast3D

var service_movement : ServiceActorMovement = ServiceActorMovement.new(self)
var service_animation  : ServiceActorAnimation = ServiceActorAnimation.new(self)
var service_abilities

var friction : float = FRICTION_DEFAULT
var velocity_last : Vector3

func _ready():
	if controller:
		controller.initialize(self)
	initialize()

func _physics_process(delta):
	if not velocity.z == 0.0 and not velocity.x == 0.0:
		velocity_last = velocity

	if _pivot:
		_pivot.move(atan2(velocity_last.x, velocity_last.z))

	move_and_slide()

	if not is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, delta)
		velocity.y += GameScene.gravity * GameScene.vector_gravity.y * delta
		velocity.z = lerp(velocity.z, 0.0, delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.y = 0.0
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	if abs(velocity.x) < 0.1:
		velocity.x = 0.0
	if abs(velocity.z) < 0.1:
		velocity.z = 0.0

func initialize()->void:
	if _input_manager:
		_input_manager.enabled = true
	if _springarm:
		_springarm.enabled = true
	if _statemachine:
		_statemachine.initialize(self)

func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func get_target_position()->Vector3:
	if _target_position:
		return _target_position.global_position
	return Vector3.ZERO

func is_moving()->bool:
	return not velocity == Vector3.ZERO

func can_see_actor(actor : Actor)->bool:
	if _ray_target:
		_ray_target.look_at(actor.get_target_position(), Vector3.UP)
		_ray_target.force_raycast_update()
		var c : Node3D = _ray_target.get_collider()
		if c:
			if c is Actor:
				return true
	return false

func get_input_manager()->InputManager:
	return _input_manager

func get_springarm()->SpringArm:
	return _springarm
