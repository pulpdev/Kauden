extends CharacterBody3D
class_name Actor

static var MIN_DIST_TO_LOCATION : float = 1.0:
	set(x):return

static var MIN_DIST_TO_ANGLE : float = 1.0:
	set(x):return

var direction : Vector3
var speed_move : float = 10.0
var controller : Controller:
	set(c):
		if controller:
			controller.queue_free()
		controller = c
		add_child(c)

@onready var pivot : Node3D = $Pivot

func _ready():
	controller = ActorController.new(self)
	controller.destination = get_tree().current_scene.get_node("MeshInstance3D").global_position

func move(vector : Vector3, speed : float):
	velocity.x = vector.x * speed
	velocity.z = vector.z * speed
	if not is_on_floor():
		velocity.y -= 1.0
	move_and_slide()

func near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func near_rotation(rot : float, min_dist : float = MIN_DIST_TO_ANGLE)->bool:
	return abs(pivot.global_rotation.y - rot) < min_dist
