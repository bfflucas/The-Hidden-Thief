extends StaticBody2D

var robado: bool = false


func robar() -> bool:
	if robado:
		return false

	robado = true

	GameManager.activar_alarma()

	queue_free()

	return true
