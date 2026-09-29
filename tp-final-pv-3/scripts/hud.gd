extends CanvasLayer

@onready var tiempo_label: Label = $TiempoLabel
@onready var llaves_label: Label = $LlavesLabel
@onready var pantalla_resultado: Control = $PantallaResultado

@onready var titulo: Label = $PantallaResultado/Titulo
@onready var boton_principal: Button = $PantallaResultado/BotonPrincipal
@onready var boton_guardar: Button = $PantallaResultado/BotonGuardar

enum Resultado {
	DERROTA,
	VICTORIA,
	PAUSA
}

var resultado_actual: Resultado

func _ready():
	tiempo_label.visible = false
	pantalla_resultado.visible = false
	boton_guardar.visible = false

	GameManager.alarma_activada.connect(_on_alarma_activada)
	GameManager.tiempo_actualizado.connect(_on_tiempo_actualizado)
	GameManager.tiempo_agotado.connect(_on_tiempo_agotado)
	GameManager.jugador_derrotado.connect(_on_jugador_derrotado)
	GameManager.nivel_completado.connect(_on_nivel_completado)
	var player = get_tree().get_first_node_in_group("player")

	if player != null:
		player.llaves_actualizadas.connect(_on_llaves_actualizadas)
		_on_llaves_actualizadas(player.llaves.size())

func _on_alarma_activada():
	tiempo_label.visible = true
	actualizar_tiempo(GameManager.tiempo_restante)


func _on_tiempo_actualizado(tiempo_restante: float):
	actualizar_tiempo(tiempo_restante)


func actualizar_tiempo(tiempo_restante: float):
	var segundos: int = ceil(tiempo_restante)
	tiempo_label.text = str(segundos)


func _on_tiempo_agotado():
	tiempo_label.text = "0"

func _on_jugador_derrotado():
	boton_guardar.visible = false
	resultado_actual = Resultado.DERROTA

	titulo.text = "HAS SIDO ATRAPADO"
	boton_principal.text = "REINTENTAR"

	pantalla_resultado.visible = true
	get_tree().paused = true

func _on_boton_principal_pressed():
	if resultado_actual == Resultado.PAUSA:
		cerrar_pausa()
		return

	get_tree().paused = false

	if resultado_actual == Resultado.DERROTA:
		GameManager.reiniciar_nivel_actual()

	elif resultado_actual == Resultado.VICTORIA:
		GameManager.siguiente_nivel()

func _on_boton_menu_pressed():
	get_tree().paused = false
	GameManager.reiniciar_estado()
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func _on_nivel_completado():
	boton_guardar.visible = false
	resultado_actual = Resultado.VICTORIA

	titulo.text = "ROBO COMPLETADO"
	boton_principal.text = "CONTINUAR"

	pantalla_resultado.visible = true
	get_tree().paused = true


func _unhandled_input(event):  #funcion de Godot para recibir entradas del teclado/mouse que todavía no fueron consumidas por otro nodo
	if event.is_action_pressed("pause"):
		if GameManager.partida_terminada:
			return

		if resultado_actual == Resultado.PAUSA and pantalla_resultado.visible:
			cerrar_pausa()
		else:
			abrir_pausa()
			
func abrir_pausa():
	resultado_actual = Resultado.PAUSA

	titulo.text = "PAUSA"
	boton_principal.text = "REANUDAR"
	boton_guardar.visible = true

	pantalla_resultado.visible = true
	get_tree().paused = true


func cerrar_pausa():
	pantalla_resultado.visible = false
	boton_guardar.visible = false
	get_tree().paused = false			


func _on_boton_guardar_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		print("ERROR: No se encontró al Player")
		return

	SaveManager.guardar_checkpoint(
		player.global_position,
		GameManager.nivel_actual,
		player.llaves
	)

	print("PARTIDA GUARDADA")
	print("Nivel: ", GameManager.nivel_actual)
	print("Posición: ", player.global_position)


func _on_llaves_actualizadas(_cantidad: int):
	var player = get_tree().get_first_node_in_group("player")

	if player == null or player.llaves.is_empty():
		llaves_label.text = "Llaves: 0"
		return

	llaves_label.text = "Llaves:\n" + "\n".join(player.llaves)
