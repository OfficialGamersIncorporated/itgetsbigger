extends RigidBody3D
class_name ThingCollector

@onready var visual : MeshInstance3D = $MeshInstance3D
@onready var collisionShape : CollisionShape3D = $CollisionShape3D
@onready var collectedProps : Node3D = $CollectedProps

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

func ConsumeBody(other : Prop):
	var volume = other.Volume
	IncrementVolume(volume)
	other.reparent(collectedProps, true)
	other.SetPassive(true)

func RemoveRandomProp():
	var props = collectedProps.get_children()
	var randomProp : Prop = props[randi() % props.size()]
	randomProp.reparent(PropManager.Singleton, true)
	randomProp.SetPassive(false)
	return randomProp

func Damage(damagePercent : float):
	var modifier = (100 - damagePercent) / 100
	var lostVolume = CurrentVolume * (1 - modifier)
	CurrentVolume *= modifier
	RecalculateScale()
	
	var propCount = collectedProps.get_children().size()
	var countToKill = ceil(propCount * (1 - modifier))
	print(countToKill)
	for i in countToKill:
		RemoveRandomProp().Volume = lostVolume / countToKill

func _ready() -> void:
	CurrentVolume = (4/3) * PI * pow(.5, 3.0)
	RecalculateScale()
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func  _physics_process(delta: float) -> void:
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.get_collision_layer_value(3):
			Damage(10)
			return
		
		if not body.is_class("RigidBody3D"): continue
		ConsumeBody(body)
