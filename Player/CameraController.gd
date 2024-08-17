extends Camera3D

@onready var target : Node3D = $".."

@export var MinTargetDistance : float = 15
@export var MaxTargetDistance : float = 25
@export var DesiredElevation : float = 7.5
@export var MoveSpeed : float = 5

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	look_at(target.global_position)
	
	global_position.y = move_toward(global_position.y, target.global_position.y + DesiredElevation, MoveSpeed * delta)
	global_position.y = max(global_position.y, target.global_position.y)
	
	var planarTargetPos = target.global_position
	planarTargetPos.y = global_position.y
	var deltaVector = (planarTargetPos - global_position)
	var targetDistance = deltaVector.length() #(deltaVector - deltaVector.project(Vector3.UP)).length()
	var desiredDistance = clampf(targetDistance, MinTargetDistance, MaxTargetDistance)
	var deltaDistance = targetDistance - desiredDistance # can be negative
	global_position = global_position.move_toward(planarTargetPos, deltaDistance)
