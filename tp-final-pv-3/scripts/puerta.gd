extends StaticBody2D

@export_category("Llave")
@export var id_llave_necesaria: String = ""

@export_category("Sprites")
@export var region_cerrada: Rect2
@export var region_abierta: Rect2

@onready var sprite: Sprite2D = $Sprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D

var abierta: bool = false


func _ready():
	actualizar_estado()


func intentar_abrir(player) -> bool:

	if abierta:
		return true

	if id_llave_necesaria == "":
		abrir()
		return true

	if player.consumir_llave(id_llave_necesaria):
		abrir()
		return true

	print("Falta la llave: ", id_llave_necesaria)
	return false


func abrir():
	abierta = true
	actualizar_estado()


func actualizar_estado():

	if abierta:
		sprite.region_rect = region_abierta
		colision.set_deferred("disabled", true)

	else:
		sprite.region_rect = region_cerrada
		colision.set_deferred("disabled", false)
