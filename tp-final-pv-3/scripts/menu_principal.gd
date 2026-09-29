extends Control

@onready var boton_continuar: Button = $BotonContinuar
@onready var pantalla_dificultad: Control = $PantallaDificultad
@onready var pantalla_opciones: Control = $PantallaOpciones
@onready var volumen_musica: HSlider = $PantallaOpciones/VolumenMusica
@onready var volumen_efectos: HSlider = $PantallaOpciones/VolumenEfectos

func _ready():
	AudioManager.detener_musica()
	boton_continuar.visible = SaveManager.existe_partida()

func _on_boton_salir_pressed():
	get_tree().quit()


func _on_boton_nueva_partida_pressed() -> void:
	pantalla_dificultad.visible = true


func _on_boton_continuar_pressed() -> void:
	if SaveManager.hay_guardado_manual:
		GameManager.cargar_nivel(SaveManager.nivel_guardado)
	else:
		GameManager.cargar_nivel(SaveManager.nivel_desbloqueado)


func _on_boton_volver_pressed() -> void:
	pantalla_dificultad.visible = false


func _on_boton_facil_pressed() -> void:
	iniciar_nueva_partida("facil")


func _on_boton_normal_pressed() -> void:
	iniciar_nueva_partida("normal")


func _on_boton_dificil_pressed() -> void:
	iniciar_nueva_partida("dificil")

func iniciar_nueva_partida(dificultad_elegida: String):
	SaveManager.borrar_partida()
	SaveManager.dificultad = dificultad_elegida
	SaveManager.partida_iniciada = true
	SaveManager.guardar_partida()
	GameManager.cargar_nivel(0)


func _on_boton_opciones_pressed() -> void:
	volumen_musica.value = SaveManager.volumen_musica * 100.0
	volumen_efectos.value = SaveManager.volumen_efectos * 100.0
	pantalla_opciones.visible = true


func _on_boton_volver_opciones_pressed() -> void:
	pantalla_opciones.visible = false


func _on_volumen_musica_value_changed(value: float) -> void:
	SaveManager.volumen_musica = value / 100.0
	AudioManager.aplicar_volumen_musica()
	SaveManager.guardar_partida()


func _on_volumen_efectos_value_changed(value: float) -> void:
	SaveManager.volumen_efectos = value / 100.0
	AudioManager.aplicar_volumen_efectos()
	SaveManager.guardar_partida()
