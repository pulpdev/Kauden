@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

enum FACTIONS {GOOD, EVIL, NEUTRAL}

const MIN_DIST_TO_LOCATION : float = 0.3
const FRICTION_DEFAULT : float = 20.0

@export var controller : ControllerActor
@export var stats : StatManager
@export var data : ActorData
@export var pivot : Pivot
@export var eyes : Eyes
@export var target_position : Marker3D
@export var faction : FACTIONS = FACTIONS.NEUTRAL
@export var ability_manager : AbilityManager

var friction : float = FRICTION_DEFAULT
var velocity_last : Vector3

var service_movement : ServiceActorMovement = ServiceActorMovement.new(self)

func _ready():
	if controller:
		controller.initialize(self)
	return

func _physics_process(delta):
	if not velocity.z == 0.0 and not velocity.x == 0.0:
		velocity_last = velocity

	if pivot:
		pivot.move(atan2(velocity_last.x, velocity_last.z))

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
		velocity.x= 0.0
	if abs(velocity.z) < 0.1:
		velocity.z = 0.0

func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func get_target_position()->Vector3:
	if target_position:
		return target_position.global_position
	return Vector3.ZERO

func is_moving()->bool:
	return not velocity == Vector3.ZERO

func can_see_actor(actor : Actor)->bool:
	if controller:
		controller
	return true
