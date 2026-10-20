
extends Node2D

var titulos_niveles: Array[String] = [
	"NIVEL 1 - EL MUSEO",
	"NIVEL 2 - LA MANSIÓN",
	"NIVEL 3 - EL BANCO"
]
@onready var ventana: AnimatedSprite2D = $Ventana
@onready var ladron: AnimatedSprite2D = $Ladron
@onready var nombre_nivel: Label = $NombreNivel


func _ready() -> void:
	nombre_nivel.text = titulos_niveles[GameManager.nivel_actual]
	nombre_nivel.modulate.a = 0.0

	ventana.play("viento")
	animar_entrada_ladron()


func animar_entrada_ladron() -> void:
	ladron.play("walk_left_up")

	var destino: Vector2 = ventana.position + Vector2(0, 35)

	var tween := create_tween()
	tween.tween_property(ladron, "position", destino, 3.0)

	await tween.finished

	ladron.hide()
	
	await get_tree().create_timer(0.5).timeout

	var tween_texto := create_tween()
	tween_texto.tween_property(nombre_nivel, "modulate:a", 1.0, 1.5)
	
	await tween_texto.finished

	# Mantener el título visible durante 2 segundos
	await get_tree().create_timer(2.0).timeout

	# Desvanecer toda la presentación
	var tween_salida := create_tween()
	tween_salida.tween_property(self, "modulate:a", 0.0, 1.5)

	await tween_salida.finished

	# Cargar el nivel correspondiente
	GameManager.cargar_nivel(GameManager.nivel_actual)
