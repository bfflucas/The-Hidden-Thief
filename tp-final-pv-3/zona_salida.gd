extends Area2D


func _on_body_entered(body):

	print("ALGO ENTRO EN ZONA SALIDA: ", body.name)

	if body.name != "Player":
		return

	print("ENTRO EL PLAYER")

	if GameManager.tiene_tesoro:
		print("PLAYER TIENE EL TESORO")
		GameManager.completar_nivel()
	else:
		print("PLAYER NO TIENE EL TESORO")
