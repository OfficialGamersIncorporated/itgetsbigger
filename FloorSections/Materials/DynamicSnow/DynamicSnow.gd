extends MeshInstance3D

@onready var area : Area3D = $Area3D
@onready var displaceMap : Image
@export var displaceMapSize : Vector2i = Vector2i(256, 256)
@export var imprintImage : Image
@export var imprintImageSize : Vector2i
@onready var imprintRect2 : Rect2 = Rect2(0, 0, imprintImageSize.x, imprintImageSize.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	displaceMap = Image.create(displaceMapSize.x, displaceMapSize.y, false, Image.FORMAT_L8)
	displaceMap.fill(Color.WHITE)
	SendTextureToGPU()

func  SendTextureToGPU():
	RenderingServer.global_shader_parameter_set("SnowDisplacementMap", ImageTexture.create_from_image(displaceMap))

func CreateImprint(uvPos : Vector2):
	var fillImage : Image = Image.create(imprintRect2.size.x, imprintRect2.size.y, false, Image.FORMAT_L8)
	fillImage.fill(Color.BLACK)
	
	var coords = (Vector2(displaceMapSize.x, displaceMapSize.y) * uvPos)
	coords = Vector2i(coords.x, coords.y) - imprintImageSize / 2
	
	displaceMap.blend_rect_mask(fillImage, imprintImage, imprintRect2, coords)
	SendTextureToGPU()

func GetUVFromWorldPos(worldPos : Vector3):
	var visualMesh : QuadMesh = mesh
	var localPos = global_transform * worldPos
	var uv = Vector2(localPos.x, localPos.z) / visualMesh.size + Vector2.ONE/2
	return uv

func _process(_delta: float) -> void:
	#var uv : Vector2 = Vector2(randf(), randf())
	#CreateImprint(uv)
	pass

func _physics_process(_delta: float) -> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		var uv = GetUVFromWorldPos(body.global_position)
		CreateImprint(uv)
