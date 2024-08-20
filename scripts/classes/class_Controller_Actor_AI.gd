extends ControllerActor
class_name ControllerAI

#@export var VisionArea : Area3D
#@export var TargetRay : RayCast3D
#@export var FightRay : RayCast3D
#@export var TargetDelay : Timer
#
#func _ready():
	#return
	#TargetDelay.timeout.connect(on_target_delay_timeout)
#
#func get_visible_actors()->Array:
	#var a : Array
	#for b in VisionArea.get_overlapping_bodies():
		#if not b == actor:
			#a.append(b)
	#return a
#
#func get_audible_actors()->Array:
	#var a : Array
	#for b in TargetArea.get_overlapping_bodies():
		#if not b == actor:
			#a.append(b)
	#return a
#
#func can_target_actor(actor : Actor)->bool:
	#if actor == self.actor:
		#return false
	#if VisionArea.get_overlapping_bodies().has(actor):
		#if not TargetRay.global_transform.origin.is_equal_approx(actor.Controller.TargetPosition.global_position):
			#TargetRay.look_at(actor.Controller.TargetPosition.global_position)
		#else:
			#return false
		#TargetRay.force_raycast_update()
		#return TargetRay.get_collider() == actor
	#return false
#
#func on_target_delay_timeout()->void:
	#if target == null:
		#for b in get_visible_actors():
			#if can_target_actor(b):
				#target = b
	#else:
		#if not can_target_actor(target):
			#target = null
