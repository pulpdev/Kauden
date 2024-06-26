extends ControllerActor
class_name ControllerAI

@export var AudialArea : Area3D
@export var VisionArea : Area3D
@export var TargetRay : RayCast3D
@export var FightRay : RayCast3D
@export var TargetDelay : Timer

var target : Actor

func _ready():
	TargetDelay.timeout.connect(on_target_delay_timeout)

func get_visible_actors()->Array:
	var a : Array
	for b in VisionArea.get_overlapping_bodies():
		if not b == actor:
			a.append(b)
	return a

func get_audible_actors()->Array:
	var a : Array
	for b in AudialArea.get_overlapping_bodies():
		if not b == actor:
			a.append(b)
	return a

func can_target_actor(actor : Actor)->bool:
	if VisionArea.get_overlapping_bodies().has(actor):
		TargetRay.look_at(actor.Controller.TargetPosition.global_position)
		TargetRay.force_raycast_update()
		return TargetRay.get_collider() == actor
	return false

func on_target_delay_timeout()->void:
	if target == null:
		for b in get_visible_actors():
			if can_target_actor(b):
				target = b
	else:
		if not can_target_actor(target):
			target = null
