extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var punto_entrada: Marker2D = $PuntoEntrada


func _ready():
	if SaveManager.hay_guardado_manual \
	and SaveManager.nivel_guardado == GameManager.nivel_actual:

		# RESTAURAR PLAYER
		player.global_position = SaveManager.posicion_player
		player.llaves = SaveManager.llaves_player.duplicate()
		player.llaves_actualizadas.emit(player.llaves.size())


		# RESTAURAR GUARDIAS
		var guardias = get_tree().get_nodes_in_group("guardias")

		for guardia in guardias:
			var nombre_guardia: String = str(guardia.name)


			# RESTAURAR POSICION
			if nombre_guardia in SaveManager.posiciones_guardias:
				var datos_guardia = SaveManager.posiciones_guardias[nombre_guardia]

				guardia.global_position = Vector2(
					float(datos_guardia["x"]),
					float(datos_guardia["y"])
				)


			# RESTAURAR LLAVE
			if nombre_guardia in SaveManager.llaves_guardias:
				guardia.id_llave = str(
					SaveManager.llaves_guardias[nombre_guardia]
				)

				if guardia.id_llave == "":
					guardia.icono_llave.visible = false
				else:
					guardia.icono_llave.visible = true
					guardia.icono_llave.play("girar")


			# RESTAURAR ESTADO DE IA
			if nombre_guardia in SaveManager.estados_guardias:
				var datos_estado = SaveManager.estados_guardias[nombre_guardia]

				guardia.estado_actual = int(
					datos_estado["estado_actual"]
				)

				guardia.posicion_sospechosa = Vector2(
					float(datos_estado["posicion_sospechosa_x"]),
					float(datos_estado["posicion_sospechosa_y"])
				)

				guardia.ultima_posicion_player = Vector2(
					float(datos_estado["ultima_posicion_player_x"]),
					float(datos_estado["ultima_posicion_player_y"])
				)
				
				guardia.fase_alerta = int(
					datos_estado["fase_alerta"]
				)

				guardia.tiempo_alerta_actual = float(
					datos_estado["tiempo_alerta_actual"]
				)

				guardia.tiempo_sin_ver_player = float(
					datos_estado["tiempo_sin_ver_player"]
				)

				guardia.actualizar_estado_restaurado()


		# RESTAURAR ALARMA
		if SaveManager.alarma_guardada:
			GameManager.restaurar_alarma(
				SaveManager.tiempo_alarma_guardado
			)

	else:
		# NUEVA PARTIDA / ENTRADA NORMAL AL NIVEL
		player.global_position = punto_entrada.global_position


	# MUSICA
	if GameManager.alarma_activa:
		AudioManager.reproducir_musica_alarma()
	else:
		AudioManager.reproducir_musica_normal()
