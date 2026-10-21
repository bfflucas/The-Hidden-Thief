extends Node2D

@onready var mensaje_tutorial: RichTextLabel = $CanvasLayer/MensajeTutorial
@onready var llave: Area2D = $Llave
@onready var puerta = $Puerta
@onready var puerta2 = $Puerta2
@onready var player: CharacterBody2D = $Player
@onready var guardia = $Guardia
@onready var reaparicion: Marker2D = $Reaparicion
@onready var zona_salida = $ZonaSalida
@onready var tesoro = $Tesoro
@onready var boton_volver_menu: Button = $CanvasLayer/BotonVolverMenu

var direcciones: Dictionary = {
	"ARRIBA": false,
	"ABAJO": false,
	"IZQUIERDA": false,
	"DERECHA": false,
	"ARRIBA-IZQUIERDA": false,
	"ARRIBA-DERECHA": false,
	"ABAJO-IZQUIERDA": false,
	"ABAJO-DERECHA": false
}

var movimiento_completado: bool = false
var correr_completado: bool = false
var sigilo_completado: bool = false
var llave_completada: bool = false
var puerta_completada: bool = false
var puerta2_completada: bool = false
var llave_guardia_completada: bool = false
var tesoro_completado: bool = false
var tutorial_completado: bool = false


func _ready():
	zona_salida.tutorial_completado.connect(_on_tutorial_completado)
	llave.visible = false
	llave.monitoring = false
	actualizar_mensaje_movimiento()
	guardia.jugador_atrapado_tutorial.connect(_on_jugador_atrapado_tutorial)
	boton_volver_menu.hide()
	get_tree().paused = true
	

func _process(_delta):

	if tutorial_completado:
		return

	# ETAPA 9: ROBAR EL TESORO
	if puerta2_completada:
		if not tesoro_completado and not is_instance_valid(tesoro):
			tesoro_completado = true

			mensaje_tutorial.text = "[center][color=green]✓ ¡ROBASTE EL TESORO![/color]\n\nREGRESÁ A LA VENTANA POR DONDE ENTRASTE PARA ESCAPAR[/center]"

		return

	# ETAPA 8: ABRIR LA SEGUNDA PUERTA
	if llave_guardia_completada:
		if not puerta2_completada and puerta2.abierta:
			puerta2_completada = true

			mensaje_tutorial.text = "[center][color=green]✓ ¡ABRISTE LA SEGUNDA PUERTA![/color]\n\nENTRÁ A LA ÚLTIMA HABITACIÓN Y ROBÁ EL TESORO PRESIONANDO E[/center]"

		return

	# ETAPA 7: ROBAR LA LLAVE DEL GUARDIA
	if puerta_completada:
		if not llave_guardia_completada and guardia.id_llave == "":
			llave_guardia_completada = true

			mensaje_tutorial.text = "[center][color=green]✓ ¡LE ROBASTE LA LLAVE AL GUARDIA![/color]\n\nAHORA BUSCÁ LA SEGUNDA PUERTA Y PRESIONÁ E PARA ABRIRLA[/center]"

		return

	# ETAPA 6: ABRIR LA PRIMERA PUERTA
	if llave_completada:
		if not puerta_completada and puerta.abierta:
			puerta_completada = true

			mensaje_tutorial.text = "[center][color=green]✓ ¡ABRISTE LA PRIMERA PUERTA![/color]\n\nEVITÁ LA LINTERNA DEL GUARDIA, ACERCATE POR DETRÁS O DE COSTADO EN MODO SIGILO Y PRESIONÁ E PARA ROBARLE LA LLAVE\n
			\n[color=red]¡IMPORTANTE! SI VAS EN SIGILO LOS GUARDIAS NO PODRÁN VERTE NI OÍRTE, A NO SER QUE TE VEAN CON SU LINTERNA.[/color][/center]"

		return

	# ETAPA 5: RECOGER LA PRIMERA LLAVE
	if sigilo_completado:
		if not llave_completada and not is_instance_valid(llave):
			llave_completada = true

			mensaje_tutorial.text = "[center][color=green]✓ ¡RECOGISTE LA LLAVE![/color]\n\nACERCATE A LA PUERTA Y PRESIONÁ E PARA ABRIRLA[/center]"

		return

	# ETAPA 4: APRENDER SIGILO
	if correr_completado:
		var dir_sigilo: Vector2 = Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		)

		if Input.is_action_pressed("stealth") and dir_sigilo != Vector2.ZERO:
			sigilo_completado = true

			llave.visible = true
			llave.set_deferred("monitoring", true)

			mensaje_tutorial.text = "[center][color=green]✓ ¡APRENDISTE A CAMINAR EN SIGILO![/color]\n\nBUSCÁ LA LLAVE Y PRESIONÁ E PARA RECOGERLA[/center]"

		return

	# ETAPA 3: APRENDER A CORRER
	if movimiento_completado:
		var dir_correr: Vector2 = Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		)

		if Input.is_action_pressed("run") and dir_correr != Vector2.ZERO:
			correr_completado = true

			mensaje_tutorial.text = "[center][color=green]✓ ¡APRENDISTE A CORRER![/color]\n\nAHORA MANTENÉ ESPACIO PARA CAMINAR EN SIGILO[/center]"

		return

	# ETAPA 1: PRACTICAR LAS 8 DIRECCIONES
	var dir: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if dir == Vector2.ZERO:
		return

	var nombre_direccion: String = ""

	if dir.x < 0 and dir.y < 0:
		nombre_direccion = "ARRIBA-IZQUIERDA"
	elif dir.x > 0 and dir.y < 0:
		nombre_direccion = "ARRIBA-DERECHA"
	elif dir.x < 0 and dir.y > 0:
		nombre_direccion = "ABAJO-IZQUIERDA"
	elif dir.x > 0 and dir.y > 0:
		nombre_direccion = "ABAJO-DERECHA"
	elif dir.y < 0:
		nombre_direccion = "ARRIBA"
	elif dir.y > 0:
		nombre_direccion = "ABAJO"
	elif dir.x < 0:
		nombre_direccion = "IZQUIERDA"
	elif dir.x > 0:
		nombre_direccion = "DERECHA"

	if nombre_direccion != "":
		if not direcciones[nombre_direccion]:
			direcciones[nombre_direccion] = true
			actualizar_mensaje_movimiento()

	if false not in direcciones.values():
		movimiento_completado = true

		mensaje_tutorial.text = "[center][color=green]¡MUY BIEN!\nCOMPLETASTE LAS 8 DIRECCIONES[/color]\n\nAHORA MANTENÉ SHIFT PARA CORRER[/center]"


func actualizar_mensaje_movimiento():
	var mensaje: String = "[center]PRACTICÁ LAS 8 DIRECCIONES:[/center]\n\n"

	mensaje += "[left]"

	for nombre in direcciones:
		if direcciones[nombre]:
			mensaje += "[color=green]✓ " + nombre + "[/color]\n"
		else:
			mensaje += "[color=white]○ " + nombre + "[/color]\n"

	mensaje += "[/left]"

	mensaje_tutorial.text = mensaje

func _on_jugador_atrapado_tutorial():
	player.global_position = reaparicion.global_position
	player.velocity = Vector2.ZERO

	guardia.velocity = Vector2.ZERO
	guardia.navigation_agent.target_position = guardia.global_position
	guardia.indice_objetivo = 0
	guardia.cambiar_estado(guardia.Estado.PATRULLA)

	mensaje_tutorial.text = "[center][color=red]¡EL GUARDIA TE DESCUBRIÓ![/color]\n\nEVITÁ LA LINTERNA DEL GUARDIA, ACERCATE POR DETRÁS EN MODO SIGILO Y PRESIONÁ E PARA ROBARLE LA LLAVE[/center]"

func _on_tutorial_completado() -> void:
	if tutorial_completado:
		return

	tutorial_completado = true

	mensaje_tutorial.text = "[center][color=green]¡FELICITACIONES![/color]\n\n¡COMPLETASTE EL TUTORIAL!\n\nYA ESTÁS LISTO PARA COMENZAR TU AVENTURA.[/center]"

	boton_volver_menu.show()

	get_tree().paused = true
	
func _on_boton_volver_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/niveles/menu_principal.tscn")	
	
func _on_boton_comenzar_pressed() -> void:
	$PantallaConsejos.hide()
	get_tree().paused = false	


func _on_boton_volver_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/niveles/menu_principal.tscn")
