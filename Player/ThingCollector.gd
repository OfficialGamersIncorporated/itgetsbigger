extends RigidBody3D
class_name ThingCollector

@onready var visual : MeshInstance3D = $MeshInstance3D
@onready var collisionShape : CollisionShape3D = $CollisionShape3D

@onready var CurrentVolume : float = 4

func RecalculateScale():
	# google's stupid ai says this is right so it must be true.
	var radius = pow((CurrentVolume * 3) / 4 * PI, 1.0 / 3.0)
	
	var newScale = Vector3.ONE * radius * 2
	visual.scale = newScale
	var shape : SphereShape3D = collisionShape.shape
	shape.radius = radius

func IncrementVolume(deltaVolume : float):
	CurrentVolume += deltaVolume
	RecalculateScale()

func ConsumeBody(other : RigidBody3D):
	var volume = PropManager.GetVolumeOfObject(other)
	IncrementVolume(volume)
	other.reparent(self, true)
	other.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	other.freeze = true
	#other.set_collision_layer_value(2, true)
	#other.set_collision_layer_value(1, false) # doesn't work.
	for child in other.get_children(true):
		if child.is_class("CollisionShape3D"):
			child.free()

func _ready() -> void:
	CurrentVolume = (4/3) * PI * pow(.5, 3.0)
	RecalculateScale()
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func  _physics_process(delta: float) -> void:
	var bodies = get_colliding_bodies()
	for body in bodies:
		if not body.is_class("RigidBody3D"): continue
		ConsumeBody(body)
