extends CanvasLayer

@onready var tiempo_label: Label = $TiempoLabel


func _ready():
	tiempo_label.visible = false

	GameManager.alarma_activada.connect(_on_alarma_activada)
	GameManager.tiempo_actualizado.connect(_on_tiempo_actualizado)
	GameManager.tiempo_agotado.connect(_on_tiempo_agotado)


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
