extends CharacterBody2D

@export_category("Movimiento")
@export var velocidad_normal: float = 150.0
@export var velocidad_sigilo: float = 70.0
@export var velocidad_correr: float = 230.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var event_input_direction := Vector2.ZERO


func _input(event):

	if event.is_action_pressed("move_left"):
		event_input_direction.x = -1

	elif event.is_action_pressed("move_right"):
		event_input_direction.x = 1

	elif event.is_action_released("move_left") or event.is_action_released("move_right"):
		event_input_direction.x = Input.get_axis("move_left", "move_right")


	if event.is_action_pressed("move_up"):
		event_input_direction.y = -1

	elif event.is_action_pressed("move_down"):
		event_input_direction.y = 1

	elif event.is_action_released("move_up") or event.is_action_released("move_down"):
		event_input_direction.y = Input.get_axis("move_up", "move_down")


	if event.is_action_pressed("interact"):
		interactuar()


func _physics_process(_delta):

	var dir = event_input_direction

	if dir.length() > 0:
		dir = dir.normalized()
		reproducir_animacion(dir)
	else:
		sprite.play("Idle")

	var velocidad_actual = obtener_velocidad_actual()

	velocity = dir * velocidad_actual
	move_and_slide()


func obtener_velocidad_actual() -> float:

	if Input.is_action_pressed("stealth"):
		return velocidad_sigilo

	elif Input.is_action_pressed("run"):
		return velocidad_correr

	return velocidad_normal


func interactuar():
	print("Interactuar")


func reproducir_animacion(dir):

	if dir.x < 0 and dir.y < 0:
		sprite.play("walk_left_up")

	elif dir.x > 0 and dir.y < 0:
		sprite.play("walk_right_up")

	elif dir.x < 0 and dir.y > 0:
		sprite.play("walk_left_down")

	elif dir.x > 0 and dir.y > 0:
		sprite.play("walk_right_down")

	elif dir.x < 0:
		sprite.play("walk_left")

	elif dir.x > 0:
		sprite.play("walk_right")

	elif dir.y < 0:
		sprite.play("walk_up")

	elif dir.y > 0:
		sprite.play("walk_down")
