extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var punto_entrada: Marker2D = $PuntoEntrada


func _ready():
	if SaveManager.hay_guardado_manual \
	and SaveManager.nivel_guardado == GameManager.nivel_actual:
		player.global_position = SaveManager.posicion_player
		player.llaves = SaveManager.llaves_player.duplicate()
		player.llaves_actualizadas.emit(player.llaves.size())
		if SaveManager.alarma_guardada:
			GameManager.restaurar_alarma(SaveManager.tiempo_alarma_guardado)
	else:
		player.global_position = punto_entrada.global_position

	if GameManager.alarma_activa:
		AudioManager.reproducir_musica_alarma()
	else:
		AudioManager.reproducir_musica_normal()
