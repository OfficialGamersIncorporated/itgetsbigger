extends ThingCollector
class_name Player

@onready var Camera : Camera3D = $Camera3D

@export var Acceleration : float = 10
@export var FallAndRespawnHeight : float = -15

@onready var LastCheckpoint : Vector3 = global_position
var MoveVector : Vector2 = Vector2.ZERO

func _input(_event: InputEvent) -> void:
	var moveVectX : float = Input.get_axis("walk_left", "walk_right")
	var moveVectY : float = Input.get_axis("walk_backwards", "walk_forwards")
	MoveVector = Vector2(moveVectX, moveVectY)

func _physics_process(delta: float) -> void:
	if global_position.y < FallAndRespawnHeight:
		global_position = LastCheckpoint
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
	
	super(delta)
	var camForward = Camera.global_basis * Vector3(0,0,-1)
	var camForwardPlanar = camForward - camForward.project(Vector3.UP)
	var globalVect : Vector3 = Basis.looking_at(camForwardPlanar) * Vector3(MoveVector.x, 0, -MoveVector.y)
	apply_central_force(globalVect * Acceleration)
