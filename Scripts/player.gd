extends Node2D

var clic_presionado := false
var intervalo := 0.01
var tiempo_transcurrido := 0.0
var distancia_minima := 15
var balas := []

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Botón izquierdo presionado")
				clic_presionado = true
			else:
				print("Botón izquierdo soltado")
				clic_presionado = false
				for bala in balas:
					if bala and bala.is_inside_tree():
						bala.gravity_scale = -1

func _process(delta):
	if clic_presionado:
		tiempo_transcurrido += delta
		if tiempo_transcurrido >= intervalo:
			tiempo_transcurrido = 0.0
			var mouse_pos = get_viewport().get_mouse_position()

			if not hay_escena_cercana(mouse_pos):
				var bala = load("res://Scenes/player.tscn").instantiate()
				bala.position = mouse_pos
				add_child(bala)
				balas.append(bala)

func hay_escena_cercana(posicion):
	for hijo in get_children():
		if hijo is Node2D:
			if hijo.position.distance_to(posicion) < distancia_minima:
				return true
	return false
