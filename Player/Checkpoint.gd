extends Area3D

@onready var EditorVisual : MeshInstance3D = $EditorVisual

func _ready() -> void:
	body_entered.connect(Callable(self, "Entered"))
	EditorVisual.visible = false

func Entered(other : Node3D):
	if not other is Player: return
	var player : Player = other
	player.LastCheckpoint = global_position
