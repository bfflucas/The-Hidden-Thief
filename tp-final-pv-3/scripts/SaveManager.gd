extends Node

const RUTA_GUARDADO: String = "user://partida.json"

var nivel_desbloqueado: int = 0
var volumen_musica: float = 1.0
var volumen_efectos: float = 1.0
var dificultad: String = "normal"
var partida_iniciada: bool = false

func _ready():
	cargar_partida()


func guardar_partida():

	var datos = {
		"nivel_desbloqueado": nivel_desbloqueado,
		"volumen_musica": volumen_musica,
		"volumen_efectos": volumen_efectos,
		"dificultad": dificultad,
		"partida_iniciada": partida_iniciada
	}

	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)

	archivo.store_string(JSON.stringify(datos))

func cargar_partida():

	if not FileAccess.file_exists(RUTA_GUARDADO):
		return

	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)

	var contenido = archivo.get_as_text()

	var datos = JSON.parse_string(contenido)

	if datos == null:
		return

	nivel_desbloqueado = int(datos.get("nivel_desbloqueado", 0))
	volumen_musica = float(datos.get("volumen_musica", 1.0))
	volumen_efectos = float(datos.get("volumen_efectos", 1.0))
	dificultad = str(datos.get("dificultad", "normal"))
	partida_iniciada = bool(datos.get("partida_iniciada", false))


func borrar_partida():

	if FileAccess.file_exists(RUTA_GUARDADO):
		DirAccess.remove_absolute(RUTA_GUARDADO)

	nivel_desbloqueado = 0
	dificultad = "normal"
	partida_iniciada = false

func desbloquear_nivel(indice: int):

	if indice <= nivel_desbloqueado:
		return

	nivel_desbloqueado = indice
	guardar_partida()

func existe_partida() -> bool:
	return partida_iniciada

func obtener_multiplicador_velocidad_guardias() -> float:

	match dificultad:
		"facil":
			return 0.8
		"dificil":
			return 1.2
		_:
			return 1.0


func obtener_multiplicador_tiempo_alarma() -> float:

	match dificultad:
		"facil":
			return 1.25
		"dificil":
			return 0.75
		_:
			return 1.0
