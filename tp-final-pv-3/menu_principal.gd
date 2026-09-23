extends Control


func _on_boton_jugar_pressed():
	GameManager.cargar_nivel(0)


func _on_boton_salir_pressed():
	get_tree().quit()
