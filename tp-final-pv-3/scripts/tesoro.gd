extends StaticBody2D

var robado: bool = false


func robar() -> bool:

	if robado:
		return false

	robado = true

	print("ENTRÓ EN robar()")

	GameManager.registrar_robo_tesoro()

	queue_free()

	return true
