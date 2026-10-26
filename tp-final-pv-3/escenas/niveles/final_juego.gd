extends Control

func _ready():
	AudioManager.reproducir_musica_final()

func _on_boton_menu_pressed() -> void:
	AudioManager.detener_musica()
	get_tree().paused = false
	GameManager.reiniciar_estado()
	get_tree().change_scene_to_file("res://escenas/niveles/menu_principal.tscn")
