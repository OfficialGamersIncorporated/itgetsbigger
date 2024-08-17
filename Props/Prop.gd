extends RigidBody3D
class_name Prop

@onready var Volume = GetTrueVolume()

func GetTrueVolume():
	return PropManager.GetVolumeOfObject(self)

func SetPassive(passive : bool):
	freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	freeze = passive
	
	for child in get_children(true):
		if child.is_class("CollisionShape3D"):
			child.disabled = passive
