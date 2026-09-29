extends StaticBody2D

var robado: bool = false

func _ready():
	if SaveManager.hay_guardado_manual and SaveManager.tesoro_robado:
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
