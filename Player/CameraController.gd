extends Camera3D

@onready var target : Node3D = $".."

@export var MinTargetDistance : float = 15
@export var MaxTargetDistance : float = 25
@export var DesiredElevation : float = 7.5
@export var MoveSpeed : float = 4

func _ready() -> void:
	pass

func  ProjectOnPlane(point : Vector3, planeNormal : Vector3):
	return point - point.project(planeNormal)

func _physics_process(delta: float) -> void:
	look_at(target.global_position)
	
	global_position.y = move_toward(global_position.y, target.global_position.y + DesiredElevation, MoveSpeed * delta)
	global_position.y = max(global_position.y, target.global_position.y)
	
	var planarTargetPos = ProjectOnPlane(target.global_position, Vector3.UP) + global_position.project(Vector3.UP)
	var deltaVector = (planarTargetPos - global_position)
	var targetDistance = deltaVector.length()
	var desiredDistance = clampf(targetDistance, MinTargetDistance, MaxTargetDistance)
	var deltaDistance = targetDistance - desiredDistance # can be negative
	global_position = global_position.move_toward(planarTargetPos, deltaDistance)
