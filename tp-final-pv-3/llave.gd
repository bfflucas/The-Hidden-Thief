extends Area2D

@export_category("Llave")
@export var id_llave: String = "museo_generica"

var recogida: bool = false


func quitar_llave() -> String:
	if recogida:
		return ""

	if id_llave == "":
		return ""

	recogida = true

	var llave_obtenida: String = id_llave
	id_llave = ""

	queue_free()

	return llave_obtenida
