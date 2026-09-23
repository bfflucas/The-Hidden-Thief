extends CanvasLayer

@onready var tiempo_label: Label = $TiempoLabel
@onready var pantalla_resultado: Control = $PantallaResultado

@onready var titulo: Label = $PantallaResultado/Titulo
@onready var boton_principal: Button = $PantallaResultado/BotonPrincipal

enum Resultado {
	DERROTA,
	VICTORIA
}

var resultado_actual: Resultado

func _ready():
	tiempo_label.visible = false

	GameManager.alarma_activada.connect(_on_alarma_activada)
	GameManager.tiempo_actualizado.connect(_on_tiempo_actualizado)
	GameManager.tiempo_agotado.connect(_on_tiempo_agotado)
	GameManager.jugador_derrotado.connect(_on_jugador_derrotado)
	GameManager.nivel_completado.connect(_on_nivel_completado)

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
	resultado_actual = Resultado.DERROTA

	titulo.text = "HAS SIDO ATRAPADO"
	boton_principal.text = "REINTENTAR"

	pantalla_resultado.visible = true
	get_tree().paused = true

func _on_boton_principal_pressed():
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
	resultado_actual = Resultado.VICTORIA

	titulo.text = "ROBO COMPLETADO"
	boton_principal.text = "CONTINUAR"

	pantalla_resultado.visible = true
	get_tree().paused = true
