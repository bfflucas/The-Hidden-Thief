
extends Node

var sonido_hover: AudioStream = preload("res://audio/hover.wav")
var sonido_click: AudioStream = preload("res://audio/click.mp3")

var animaciones: Dictionary = {}
var reproductor_hover: AudioStreamPlayer
var reproductor_click: AudioStreamPlayer


func _ready() -> void:
	reproductor_hover = AudioStreamPlayer.new()
	add_child(reproductor_hover)

	reproductor_click = AudioStreamPlayer.new()
	add_child(reproductor_click)

	get_tree().node_added.connect(_al_agregar_nodo)

	for nodo in get_tree().root.find_children("*", "Button", true, false):
		_configurar_boton(nodo)


func _al_agregar_nodo(nodo: Node) -> void:
	if nodo is Button:
		_configurar_boton(nodo)


func _configurar_boton(boton: Button) -> void:
	if boton.has_meta("hover_configurado"):
		return

	boton.set_meta("hover_configurado", true)

	boton.resized.connect(_actualizar_pivote.bind(boton))
	boton.mouse_entered.connect(_al_hover.bind(boton))
	boton.mouse_exited.connect(_animar.bind(boton, Vector2.ONE))
	boton.pressed.connect(_al_click)

	_actualizar_pivote(boton)


func _actualizar_pivote(boton: Button) -> void:
	boton.pivot_offset = boton.size / 2.0


func _al_hover(boton: Button) -> void:
	if boton.disabled:
		return

	_animar(boton, Vector2(1.05, 1.05))

	if sonido_hover:
		reproductor_hover.stream = sonido_hover
		reproductor_hover.play()


func _al_click() -> void:
	if sonido_click:
		reproductor_click.stream = sonido_click
		reproductor_click.play()


func _animar(boton: Button, escala: Vector2) -> void:
	if not is_instance_valid(boton):
		return

	if animaciones.has(boton):
		var anterior: Tween = animaciones[boton]
		if anterior and anterior.is_running():
			anterior.kill()

	var tween := create_tween().bind_node(boton)
	animaciones[boton] = tween

	tween.tween_property(boton, "scale", escala, 0.15)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
