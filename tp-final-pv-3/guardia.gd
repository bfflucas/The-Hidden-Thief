extends CharacterBody2D

@export_category("Movimiento")
@export var velocidad: float = 30.0

@export_category("Patrulla")
@export var puntos_patrulla: Array[Marker2D] = []
@export var distancia_llegada: float = 5.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var direccion_vision: Node2D = $DireccionVision


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


func _ready():
	indice_objetivo = 0
	
#func _ready():
	#objetivo_actual = punto_b
	#
	#print("pos_luz_left real: ", pos_luz_left_down)

func _physics_process(_delta):

	if puntos_patrulla.is_empty():
		velocity = Vector2.ZERO
		sprite.play("Idle")
		return

	var objetivo_actual: Marker2D = puntos_patrulla[indice_objetivo]

	var direccion: Vector2 = global_position.direction_to(
		objetivo_actual.global_position
	)

	var distancia: float = global_position.distance_to(
		objetivo_actual.global_position
	)

	if distancia <= distancia_llegada:
		cambiar_objetivo()
		velocity = Vector2.ZERO
		return

	direccion = direccion.normalized()

	# Movimiento real
	velocity = direccion * velocidad

	# Dirección visual limitada a 8 direcciones
	var direccion_visual: Vector2 = obtener_direccion_8(direccion)

	reproducir_animacion(direccion_visual)

	direccion_vision.rotation = direccion_visual.angle()

	actualizar_luz()

	move_and_slide()


#func _physics_process(_delta):
	#var direccion = Vector2(-1, 1)
#
	#reproducir_animacion(direccion)
	#direccion_vision.rotation = direccion.angle()
#
	#velocity = Vector2.ZERO



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
