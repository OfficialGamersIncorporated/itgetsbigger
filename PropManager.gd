extends Node3D
class_name PropManager

static var Singleton : PropManager

func _ready() -> void:
	Singleton = self

static func GetVolumeOfBox(boundingBox : Vector3):
	return boundingBox.x * boundingBox.y * boundingBox.z

static func GetVolumeOfObject(obj : RigidBody3D):
	for shape in obj.get_children():
		if not shape.is_class("VisualInstance3D"): continue
		var boundingBox : AABB = shape.get_aabb()
		return boundingBox.get_volume()
