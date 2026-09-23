extends Node

signal tiempo_actualizado(tiempo_restante: float)
signal alarma_activada
signal tiempo_agotado
signal tesoro_robado
signal jugador_derrotado
signal nivel_completado

var niveles: Array[String] = [
	"res://nivel_museo.tscn"
]

var nivel_actual: int = 0

var tiene_tesoro: bool = false
var alarma_activa: bool = false

var tiempo_escape_maximo: float = 5.0
var tiempo_restante: float = 0.0

var temporizador_activo: bool = false
var partida_terminada: bool = false

func _process(delta):

	if not temporizador_activo:
		return

	tiempo_restante -= delta

	if tiempo_restante < 0.0:
		tiempo_restante = 0.0

	tiempo_actualizado.emit(tiempo_restante)

	if tiempo_restante <= 0.0:
		temporizador_activo = false
		tiempo_agotado.emit()
		perder_partida()


func registrar_robo_tesoro():

	if tiene_tesoro:
		return

	tiene_tesoro = true
	tesoro_robado.emit()

	activar_alarma()


func activar_alarma():

	if alarma_activa:
		return

	alarma_activa = true

	tiempo_restante = tiempo_escape_maximo
	temporizador_activo = true

	alarma_activada.emit()


func detener_temporizador():

	temporizador_activo = false


func reiniciar_estado():
	tiene_tesoro = false
	alarma_activa = false

	tiempo_restante = 0.0
	temporizador_activo = false
	partida_terminada = false

func perder_partida():

	if partida_terminada:
		return

	partida_terminada = true
	temporizador_activo = false
	jugador_derrotado.emit()

func completar_nivel():

	if partida_terminada:
		return

	if not tiene_tesoro:
		return

	partida_terminada = true
	temporizador_activo = false
	nivel_completado.emit()

func cargar_nivel(indice: int):

	if indice < 0 or indice >= niveles.size():
		return

	nivel_actual = indice

	reiniciar_estado()

	get_tree().change_scene_to_file(niveles[nivel_actual])

func siguiente_nivel():

	var siguiente: int = nivel_actual + 1

	if siguiente >= niveles.size():
		print("NO HAY MÁS NIVELES")
		return

	cargar_nivel(siguiente)

func reiniciar_nivel_actual():

	reiniciar_estado()

	get_tree().reload_current_scene()
