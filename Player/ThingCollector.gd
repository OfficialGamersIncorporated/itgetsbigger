extends RigidBody3D
class_name ThingCollector

@export var CurrentVolume : float = 10

func RecalculateScale():
	# google's stupid ai says this is right so it must be true.
	var radius = 3 * CurrentVolume / 4 * PI
	
	transform.scaled_local(Vector3.ONE * radius * 2)

func GetVolumeOfBox(boundingBox : Vector3):
	return boundingBox.x * boundingBox.y * boundingBox.z

func IncrementVolume(deltaVolume : float):
	CurrentVolume += deltaVolume
	RecalculateScale()

func _ready() -> void:
	
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
