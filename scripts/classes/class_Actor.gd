@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

enum Faction {GOOD, EVIL, NEUTRAL}

const MIN_DIST_TO_LOCATION : float = 0.3
const FRICTION_DEFAULT : float = 20.0

@export var data : ActorData
@export var faction : Faction = Faction.NEUTRAL

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
@export var _variable_manager : VariableManager

@export_category("Areas")
@export var area_target : Area3D

@export_category("Rays")
@export var _ray_target : RayCast3D

@export var service_movement : ServiceActorMovement
var service_animation  : ServiceActorAnimation = ServiceActorAnimation.new(self)
var service_abilities

var velocity_tween : Tween

var friction : float = FRICTION_DEFAULT
var velocity_last : Vector3

var move_mode_motion : bool
var ml : Vector3

func _ready():
	if controller:
		controller.initialize(self)
	initialize()
	if name == "Player2":
		print(name, get_rid())
	if name == "Player":
		print(name, get_rid())

func _physics_process(delta):
	if move_mode_motion:
		var v : Vector3 = (global_position - service_animation.get_motion_position())
		velocity = v
		print(velocity)
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
	if _pivot:
		_pivot.model.service_movement.i(self)
	if service_movement:
		service_movement.i(self)

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
	
func get_variable_manager()->VariableManager:
	return _variable_manager

func on_save_data()->Game.SaveData:
	var d : Dictionary
	var sm : StatManager = _stats_manager
	for s in sm.get_stats():
		d[s.name]["modifiers"] = s.modifiers.duplicate(true)
		d[s.name]["base"] = s.base
		d[s.name]["value"] = s.value
	d["hp"] = sm.hp
	d["ap"] = sm.ap
	d["mp"] = sm.mp
	var s : Game.SaveData = Game.SaveData.new(
		scene_file_path,
		d
	)
	return s

func on_load_data(data : Dictionary)->void:
	for d in data.data:
		pass
