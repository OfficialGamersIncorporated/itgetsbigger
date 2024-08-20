extends RigidBody3D
class_name ThingCollector

@onready var visual : MeshInstance3D = $Snowball
@onready var collisionShape : CollisionShape3D = $CollisionShape3D
@onready var collectedProps : Node3D = $CollectedProps

@onready var CurrentVolume : float = 4
@export var DamageKnockback : float = 4
@export var PropEjectKnockback : float = 16

func CalculateRadiusFromVolume(volume : float):
	return pow((volume * 3) / 4 * PI, 1.0 / 3.0) / 2

func RecalculateScale():
	var radius = CalculateRadiusFromVolume(CurrentVolume)
	
	var newScale = Vector3.ONE * radius * 2
	visual.scale = newScale / 2
	var shape : SphereShape3D = collisionShape.shape
	shape.radius = radius

func IncrementVolume(deltaVolume : float):
	CurrentVolume += deltaVolume
	RecalculateScale()

func ConsumeProp(other : Prop):
	var volume = other.Volume
	if volume > CurrentVolume: return
	
	IncrementVolume(volume)
	other.reparent(collectedProps, true)
	other.SetPassive(true)
	
	var toPropVector : Vector3 = other.global_position - global_position
	toPropVector = toPropVector.normalized() * (CalculateRadiusFromVolume(CurrentVolume))
	other.global_position = global_position + toPropVector

func RemoveRandomProp():
	var props = collectedProps.get_children()
	var randomProp : Prop = props[randi() % props.size()]
	randomProp.reparent(PropManager.Singleton, true)
	randomProp.SetPassive(false)
	
	var toPropVector : Vector3 = randomProp.global_position - global_position
	var radius = CalculateRadiusFromVolume(CurrentVolume) * 1.5
	toPropVector = (toPropVector * Vector3(1, 0, 1)).normalized() * radius + Vector3.UP * radius
	randomProp.apply_central_impulse((toPropVector.normalized().lerp(Vector3.UP, .5)) * PropEjectKnockback)
	randomProp.global_position = global_position + toPropVector
	
	return randomProp

func Damage(damagePercent : float, damageOrigin : Vector3):
	var modifier = (100 - damagePercent) / 100
	var lostVolume = CurrentVolume * (1 - modifier)
	CurrentVolume *= modifier
	RecalculateScale()
	
	var propCount = collectedProps.get_children().size()
	var countToKill = ceil(propCount * (1 - modifier))
	for i in countToKill:
		var prop = RemoveRandomProp()
		prop.Volume = lostVolume / countToKill
	
	apply_central_impulse(-damageOrigin * DamageKnockback)

func _ready() -> void:
	CurrentVolume = (4.0/3.0) * PI * pow(.5, 3.0)
	RecalculateScale()
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.get_collision_layer_value(3):
			var damageVect = body.global_position - global_position
			Damage(20, damageVect)
			return
		
		if not body is Prop: continue
		ConsumeProp(body)
