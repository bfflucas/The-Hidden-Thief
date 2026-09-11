extends CharacterBody2D

enum Estado {
	PATRULLA,
	ALERTA,
	PERSECUCION
}

var estado_actual: Estado = Estado.PATRULLA
var posicion_sospechosa: Vector2

@export_category("Movimiento")
@export var velocidad: float = 30.0

@export_category("Patrulla")
@export var puntos_patrulla: Array[Marker2D] = []
@export var distancia_llegada: float = 5.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

enum FaseAlerta {
	YENDO,
	ESPERANDO
}

var fase_alerta: FaseAlerta = FaseAlerta.YENDO

@export_category("Alerta")
@export var velocidad_alerta: float = 40.0
@export var tiempo_alerta: float = 1.0
@export var distancia_investigacion: float = 8.0

var tiempo_alerta_actual: float = 0.0


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var direccion_vision: Node2D = $DireccionVision
@onready var icono_alerta: Sprite2D = $IconoAlerta

@export_category("Deteccion")
@export var player: CharacterBody2D

@export_category("Persecucion")
@export var velocidad_persecucion: float = 55.0
@export var tiempo_perder_player: float = 1.5

var ultima_posicion_player: Vector2
var tiempo_sin_ver_player: float = 0.0

# POSICION DEL HAZ DE LA LINTERNA
var pos_luz_right := Vector2(0, 4)
var pos_luz_left := Vector2(-5, 4)
var pos_luz_up := Vector2(8, -5)
var pos_luz_down := Vector2(-8, 7)
var pos_luz_right_up := Vector2(8, 4)
var pos_luz_left_up := Vector2(2, 2)
var pos_luz_right_down := Vector2(-2, 7)
var pos_luz_left_down := Vector2(-7, 7)

@onready var luz_linterna: Polygon2D = $DireccionVision/LuzLinterna

@export_category("Linterna")
@export var distancia_luz: float = 180.0
@export var angulo_luz: float = 55.0
@export var cantidad_rayos: int = 25

var indice_objetivo: int = 0

@export_category("Llave")
@export var id_llave: String = ""

@onready var icono_llave: AnimatedSprite2D = $IconoLlave

func _ready():
	indice_objetivo = 0
	icono_alerta.visible = false
	if id_llave == "":
		icono_llave.visible = false
	else:
		icono_llave.visible = true
		icono_llave.play("girar")

func _physics_process(delta):

	match estado_actual:

		Estado.PATRULLA:
			estado_patrulla(delta)

		Estado.ALERTA:
			estado_alerta(delta)

		Estado.PERSECUCION:
			estado_persecucion(delta)

func estado_patrulla(_delta):

	if player != null:
		
		if puede_ver_player():
			ultima_posicion_player = player.global_position
			tiempo_sin_ver_player = 0.0
			cambiar_estado(Estado.PERSECUCION)
			return
		
		var radio_ruido: float = player.obtener_radio_ruido()
		var distancia_player: float = global_position.distance_to(player.global_position)

		if radio_ruido > 0.0 and distancia_player <= radio_ruido:
			posicion_sospechosa = player.global_position
			cambiar_estado(Estado.ALERTA)
			return

	if puntos_patrulla.is_empty():
		velocity = Vector2.ZERO
		sprite.pause()
		return

	var objetivo_actual: Marker2D = puntos_patrulla[indice_objetivo]

	var distancia: float = global_position.distance_to(
		objetivo_actual.global_position
	)

	if distancia <= distancia_llegada:
		cambiar_objetivo()
		velocity = Vector2.ZERO
		return

	mover_con_navigation(
		objetivo_actual.global_position,
		velocidad
	)

func cambiar_estado(nuevo_estado: Estado):

	if estado_actual == nuevo_estado:
		return

	estado_actual = nuevo_estado

	match estado_actual:

		Estado.PATRULLA:
			icono_alerta.visible = false

		Estado.ALERTA:
			icono_alerta.visible = true
			fase_alerta = FaseAlerta.YENDO
			navigation_agent.target_position = posicion_sospechosa

		Estado.PERSECUCION:
			icono_alerta.visible = true

	print("Nuevo estado del guardia: ", Estado.keys()[estado_actual])

func estado_alerta(delta):
	if puede_ver_player():
			ultima_posicion_player = player.global_position
			tiempo_sin_ver_player = 0.0
			cambiar_estado(Estado.PERSECUCION)
			return

	match fase_alerta:

		FaseAlerta.YENDO:
			ir_a_investigar()

		FaseAlerta.ESPERANDO:
			esperar_en_alerta(delta)

func ir_a_investigar():

	# Mientras investiga, sigue escuchando nuevos ruidos
	if player != null:

		var radio_ruido: float = player.obtener_radio_ruido()
		var distancia_player: float = global_position.distance_to(player.global_position)

		if radio_ruido > 0.0 and distancia_player <= radio_ruido:

			posicion_sospechosa = player.global_position
			navigation_agent.target_position = posicion_sospechosa

	var distancia: float = global_position.distance_to(posicion_sospechosa)

	if distancia <= distancia_investigacion:

		velocity = Vector2.ZERO

		fase_alerta = FaseAlerta.ESPERANDO

		tiempo_alerta_actual = tiempo_alerta

		sprite.pause()

		return

	mover_con_navigation(
		posicion_sospechosa,
		velocidad_alerta
	)
	
func esperar_en_alerta(delta):

	velocity = Vector2.ZERO

	sprite.pause()

	actualizar_luz()

	# Mientras está quieto, también sigue escuchando
	if player != null:

		var radio_ruido: float = player.obtener_radio_ruido()
		var distancia_player: float = global_position.distance_to(player.global_position)

		if radio_ruido > 0.0 and distancia_player <= radio_ruido:

			posicion_sospechosa = player.global_position

			fase_alerta = FaseAlerta.YENDO

			navigation_agent.target_position = posicion_sospechosa

			return

	tiempo_alerta_actual -= delta

	if tiempo_alerta_actual <= 0.0:
		cambiar_estado(Estado.PATRULLA)
		
		
func estado_persecucion(delta):

	if player == null:
		return

	if puede_ver_player():

		ultima_posicion_player = player.global_position
		tiempo_sin_ver_player = 0.0

		mover_con_navigation(
			player.global_position,
			velocidad_persecucion
		)

	else:

		tiempo_sin_ver_player += delta

		mover_con_navigation(
			ultima_posicion_player,
			velocidad_persecucion
		)

		if tiempo_sin_ver_player >= tiempo_perder_player:

			posicion_sospechosa = ultima_posicion_player

			cambiar_estado(Estado.ALERTA)


func cambiar_objetivo():
	indice_objetivo += 1

	if indice_objetivo >= puntos_patrulla.size():
		indice_objetivo = 0


func reproducir_animacion(dir: Vector2):

	if dir.x < 0 and dir.y < 0:
		sprite.play("walk_left_up")
		direccion_vision.position = pos_luz_left_up

	elif dir.x > 0 and dir.y < 0:
		sprite.play("walk_right_up")
		direccion_vision.position = pos_luz_right_up

	elif dir.x < 0 and dir.y > 0:
		sprite.play("walk_left_down")
		direccion_vision.position = pos_luz_left_down

	elif dir.x > 0 and dir.y > 0:
		sprite.play("walk_right_down")
		direccion_vision.position = pos_luz_right_down

	elif dir.x < 0:
		sprite.play("walk_left")
		direccion_vision.position = pos_luz_left

	elif dir.x > 0:
		sprite.play("walk_right")
		direccion_vision.position = pos_luz_right

	elif dir.y < 0:
		sprite.play("walk_up")
		direccion_vision.position = pos_luz_up

	elif dir.y > 0:
		sprite.play("walk_down")
		direccion_vision.position = pos_luz_down

func obtener_direccion_8(dir: Vector2) -> Vector2:
	var angulo: float = dir.angle()
	var paso: float = PI / 4.0
	var angulo_ajustado: float = round(angulo / paso) * paso

	var direccion_8: Vector2 = Vector2.from_angle(angulo_ajustado)

	direccion_8.x = round(direccion_8.x)
	direccion_8.y = round(direccion_8.y)

	return direccion_8


func actualizar_luz():

	var puntos: PackedVector2Array = PackedVector2Array()

	puntos.append(Vector2.ZERO)

	var espacio: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var mitad_angulo: float = deg_to_rad(angulo_luz / 2.0)

	for i in range(cantidad_rayos + 1):

		var proporcion: float = float(i) / float(cantidad_rayos)

		var angulo: float = lerp(
			-mitad_angulo,
			mitad_angulo,
			proporcion
		)

		var direccion_local: Vector2 = Vector2.RIGHT.rotated(angulo)

		var origen_global: Vector2 = direccion_vision.global_position

		var direccion_global: Vector2 = direccion_local.rotated(
			direccion_vision.global_rotation
		)

		var destino_global: Vector2 = origen_global + direccion_global * distancia_luz

		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			origen_global,
			destino_global
		)

		# Usa las mismas capas que detecta físicamente el Guardia.
		query.collision_mask = collision_mask

		# Ignora al propio guardia.
		query.exclude = [get_rid()]

		var resultado: Dictionary = espacio.intersect_ray(query)

		var punto_global: Vector2

		if not resultado.is_empty():
			punto_global = resultado["position"]
		else:
			punto_global = destino_global

		var punto_local: Vector2 = direccion_vision.to_local(punto_global)

		puntos.append(punto_local)

	luz_linterna.polygon = puntos

func quitar_llave() -> String:
	if id_llave == "":
		return ""

	var llave_robada: String = id_llave

	id_llave = ""
	icono_llave.visible = false

	return llave_robada

func mover_con_navigation(objetivo: Vector2, velocidad_movimiento: float):

	navigation_agent.target_position = objetivo

	var siguiente_punto: Vector2 = navigation_agent.get_next_path_position()

	var distancia_siguiente_punto: float = global_position.distance_to(siguiente_punto)

	# Si el siguiente punto está prácticamente encima,
	# no intentamos corregir dirección constantemente.
	if distancia_siguiente_punto < 2.0:
		velocity = Vector2.ZERO
		actualizar_luz()
		return

	var direccion: Vector2 = global_position.direction_to(siguiente_punto)

	if direccion.length() > 0.0:

		direccion = direccion.normalized()

		velocity = direccion * velocidad_movimiento

		var direccion_visual: Vector2 = obtener_direccion_8(direccion)

		reproducir_animacion(direccion_visual)

		direccion_vision.rotation = direccion_visual.angle()

	else:
		velocity = Vector2.ZERO

	actualizar_luz()
	move_and_slide()

func puede_ver_player() -> bool:

	if player == null:
		return false

	var origen: Vector2 = direccion_vision.global_position
	var vector_player: Vector2 = player.global_position - origen
	var distancia_player: float = vector_player.length()

	# Fuera del alcance de la linterna
	if distancia_player > distancia_luz:
		return false

	# Dirección hacia donde mira el guardia
	var direccion_frente: Vector2 = Vector2.RIGHT.rotated(
		direccion_vision.global_rotation
	)

	var direccion_player: Vector2 = vector_player.normalized()

	var angulo_hacia_player: float = abs(
		direccion_frente.angle_to(direccion_player)
	)

	# Fuera del cono de visión
	if angulo_hacia_player > deg_to_rad(angulo_luz / 2.0):
		return false

	# Comprobar que no haya una pared en el medio
	var espacio: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		origen,
		player.global_position
	)

	query.exclude = [get_rid()]

	# Debe incluir Player + paredes/obstáculos
	query.collision_mask = collision_mask | 1

	var resultado: Dictionary = espacio.intersect_ray(query)

	if resultado.is_empty():
		return false

	return resultado["collider"] == player
