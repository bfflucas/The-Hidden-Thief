extends Node

signal tiempo_actualizado(tiempo_restante: float)
signal alarma_activada
signal tiempo_agotado

var tesoro_robado: bool = false
var alarma_activa: bool = false

var tiempo_escape_maximo: float = 60.0
var tiempo_restante: float = 0.0

var temporizador_activo: bool = false


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


func activar_alarma():

	if alarma_activa:
		return

	tesoro_robado = true
	alarma_activa = true

	tiempo_restante = tiempo_escape_maximo
	temporizador_activo = true

	alarma_activada.emit()


func detener_temporizador():

	temporizador_activo = false


func reiniciar_estado():

	tesoro_robado = false
	alarma_activa = false

	tiempo_restante = 0.0
	temporizador_activo = false
