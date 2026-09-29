extends Node

const RUTA_GUARDADO: String = "user://partida.json"

var nivel_desbloqueado: int = 0
var volumen_musica: float = 1.0
var volumen_efectos: float = 1.0
var dificultad: String = "normal"
var partida_iniciada: bool = false

var hay_guardado_manual: bool = false
var posicion_player: Vector2 = Vector2.ZERO
var nivel_guardado: int = 0
var llaves_player: Array[String] = []
var llaves_recogidas: Array[String] = []
var puertas_abiertas: Array[String] = []
var tesoro_robado: bool = false
var alarma_guardada: bool = false
var tiempo_alarma_guardado: float = 0.0
var posiciones_guardias: Dictionary = {}
var llaves_guardias: Dictionary = {}
var estados_guardias: Dictionary = {}

func _ready():
	cargar_partida()


func guardar_partida():

	var datos = {
		"nivel_desbloqueado": nivel_desbloqueado,
		"volumen_musica": volumen_musica,
		"volumen_efectos": volumen_efectos,
		"dificultad": dificultad,
		"partida_iniciada": partida_iniciada,
		
		"hay_guardado_manual": hay_guardado_manual,
		"nivel_guardado": nivel_guardado,
		"posicion_player_x": posicion_player.x,
		"posicion_player_y": posicion_player.y,
		"llaves_player": llaves_player,
		"llaves_recogidas": llaves_recogidas,
		"puertas_abiertas": puertas_abiertas,
		"tesoro_robado": tesoro_robado,
		"alarma_guardada": alarma_guardada,
		"tiempo_alarma_guardado": tiempo_alarma_guardado,
		"posiciones_guardias": posiciones_guardias,
		"llaves_guardias": llaves_guardias,
		"estados_guardias": estados_guardias
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
	
	hay_guardado_manual = bool(datos.get("hay_guardado_manual", false))
	nivel_guardado = int(datos.get("nivel_guardado", 0))

	posicion_player = Vector2(
		float(datos.get("posicion_player_x", 0.0)),
		float(datos.get("posicion_player_y", 0.0))
	)
	llaves_player.clear()

	for llave in datos.get("llaves_player", []):
		llaves_player.append(str(llave))
		
	llaves_recogidas.clear()

	for llave in datos.get("llaves_recogidas", []):
		llaves_recogidas.append(str(llave))	
	
	puertas_abiertas.clear()

	for puerta in datos.get("puertas_abiertas", []):
		puertas_abiertas.append(str(puerta))
		
	tesoro_robado = bool(datos.get("tesoro_robado", false))	#false es un valor por defecto si no encuentra uno
	alarma_guardada = bool(datos.get("alarma_guardada", false))
	tiempo_alarma_guardado = float(datos.get("tiempo_alarma_guardado", 0.0))
	
	posiciones_guardias = datos.get("posiciones_guardias", {}) #{} si carga una partida que no tenía guardadas posiciones de guardias usamos un diccionario vacio y no da error
	llaves_guardias = datos.get("llaves_guardias", {})
	estados_guardias = datos.get("estados_guardias", {})

func borrar_partida():

	if FileAccess.file_exists(RUTA_GUARDADO):
		DirAccess.remove_absolute(RUTA_GUARDADO)

	nivel_desbloqueado = 0
	dificultad = "normal"
	partida_iniciada = false
	
	hay_guardado_manual = false
	posicion_player = Vector2.ZERO
	nivel_guardado = 0
	llaves_player.clear()
	llaves_recogidas.clear()
	puertas_abiertas.clear()
	tesoro_robado = false
	alarma_guardada = false
	tiempo_alarma_guardado = 0.0
	posiciones_guardias.clear()
	llaves_guardias.clear()
	estados_guardias.clear()

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

func guardar_checkpoint(posicion: Vector2, nivel: int, llaves: Array[String]):
	hay_guardado_manual = true
	posicion_player = posicion
	nivel_guardado = nivel
	llaves_player = llaves.duplicate()
	alarma_guardada = GameManager.alarma_activa
	tiempo_alarma_guardado = GameManager.tiempo_restante
	
	posiciones_guardias.clear()
	llaves_guardias.clear()
	estados_guardias.clear()
	var guardias = get_tree().get_nodes_in_group("guardias")

	for guardia in guardias:
		posiciones_guardias[str(guardia.name)] = {
			"x": guardia.global_position.x,
			"y": guardia.global_position.y
		}
		llaves_guardias[str(guardia.name)] = guardia.id_llave
		estados_guardias[str(guardia.name)] = {
			"estado_actual": int(guardia.estado_actual), #se puede guardar como número en JSON
			"posicion_sospechosa_x": guardia.posicion_sospechosa.x,
			"posicion_sospechosa_y": guardia.posicion_sospechosa.y,

			"ultima_posicion_player_x": guardia.ultima_posicion_player.x,
			"ultima_posicion_player_y": guardia.ultima_posicion_player.y,

			"fase_alerta": int(guardia.fase_alerta),
			"tiempo_alerta_actual": guardia.tiempo_alerta_actual,
			"tiempo_sin_ver_player": guardia.tiempo_sin_ver_player
		}
	
	
	
	
	guardar_partida()
