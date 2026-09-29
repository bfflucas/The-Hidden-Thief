extends Area2D

@export_category("Llave")
@export var id_llave: String = "museo_generica"

var recogida: bool = false

func _ready():
	if SaveManager.hay_guardado_manual and id_llave in SaveManager.llaves_recogidas:
		queue_free()
		return


func quitar_llave() -> String:
	if recogida:
		return ""

	if id_llave == "":
		return ""

	recogida = true

	var llave_obtenida: String = id_llave
	
	if not id_llave in SaveManager.llaves_recogidas:
		SaveManager.llaves_recogidas.append(id_llave)
	
	id_llave = ""

	queue_free()

	return llave_obtenida
