@tool
extends StaticBody2D

@export var imagen_tesoro: Texture2D:
	set(valor):
		imagen_tesoro = valor
		if is_node_ready() and imagen_tesoro != null:
			$Sprite2D.texture = imagen_tesoro
@onready var sprite: Sprite2D = $Sprite2D

var robado: bool = false

func _ready():
	if imagen_tesoro != null:
		sprite.texture = imagen_tesoro
		
	if Engine.is_editor_hint():
		return
	
	if SaveManager.hay_guardado_manual and not SaveManager.ignorar_checkpoint and SaveManager.tesoro_robado:
		queue_free()

func robar() -> bool:

	if robado:
		return false

	robado = true

	print("ENTRÓ EN robar()")
	SaveManager.tesoro_robado = true
	GameManager.registrar_robo_tesoro()

	queue_free()

	return true
