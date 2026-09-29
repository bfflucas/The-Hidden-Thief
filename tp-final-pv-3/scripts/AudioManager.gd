extends Node

var reproductor_musica: AudioStreamPlayer
var reproductor_sfx: AudioStreamPlayer

func _ready():
	reproductor_musica = AudioStreamPlayer.new()
	reproductor_musica.bus = "Music"
	add_child(reproductor_musica)
	
	reproductor_sfx = AudioStreamPlayer.new()
	reproductor_sfx.bus = "SFX"
	add_child(reproductor_sfx)

	aplicar_volumenes()
	GameManager.alarma_activada.connect(_on_alarma_activada)

func aplicar_volumenes():
	aplicar_volumen_musica()
	aplicar_volumen_efectos()


func aplicar_volumen_musica():
	var indice_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(
		indice_bus,
		linear_to_db(SaveManager.volumen_musica)
	)


func aplicar_volumen_efectos():
	var indice_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(
		indice_bus,
		linear_to_db(SaveManager.volumen_efectos)
	)

func reproducir_musica_normal():
	var musica = load("res://audio/pink_panther.mp3")

	if musica is AudioStreamMP3:
		musica.loop = true

	reproductor_musica.stream = musica
	reproductor_musica.volume_db = 0.0
	reproductor_musica.play()

func _on_alarma_activada():
	reproducir_musica_alarma()


func reproducir_musica_alarma():
	var musica = load("res://audio/alarm.wav")

	if musica is AudioStreamMP3:
		musica.loop = true

	reproductor_musica.stop()
	reproductor_musica.stream = musica
	reproductor_musica.volume_db = 10.0
	reproductor_musica.play()

func detener_musica():
	reproductor_musica.stop()

func reproducir_sfx(ruta: String, volumen_db: float = 0.0):
	var sonido = load(ruta)

	if sonido == null:
		return

	reproductor_sfx.stream = sonido
	reproductor_sfx.volume_db = volumen_db
	reproductor_sfx.play()
