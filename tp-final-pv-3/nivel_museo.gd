extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var punto_entrada: Marker2D = $PuntoEntrada


func _ready():
	player.global_position = punto_entrada.global_position
