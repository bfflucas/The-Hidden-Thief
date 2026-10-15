extends Area2D

signal tutorial_completado

func _on_body_entered(body):
	if body.name != "Player":
		return

	if GameManager.tiene_tesoro:
		tutorial_completado.emit()
