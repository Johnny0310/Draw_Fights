extends Node2D

var clic_presionado := false
var intervalo := 0.01
var tiempo_transcurrido := 0.0
var distancia_minima := 15
var balas := []
var ammo = 100
var tipoDeBala = "res://Scenes/ataque.tscn"


# Define el origen del área válida (puedes mover esto donde desees)
var area_origen := Vector2(150, 500)
var area_tamano := Vector2(1000, 200)

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
	var area2d = get_node("EnemyHitbox/Area2D")
	
	if clic_presionado and ammo != 0:
		tiempo_transcurrido += delta
		if tiempo_transcurrido >= intervalo:
			tiempo_transcurrido = 0.0
			var mouse_pos = get_viewport().get_mouse_position()

			if esta_en_area_valida(mouse_pos) and not hay_escena_cercana(mouse_pos):
				var bala = load(tipoDeBala).instantiate()
				bala.position = mouse_pos
				add_child(bala)
				ammo -= 1
				if area2d.has_method("actualizar_texto"):
					area2d.actualizar_texto()
				balas.append(bala)

func hay_escena_cercana(posicion):
	for hijo in get_children():
		if hijo is Node2D:
			if hijo.position.distance_to(posicion) < distancia_minima:
				return true
	return false

func esta_en_area_valida(posicion: Vector2) -> bool:
	return posicion.x >= area_origen.x and posicion.x <= area_origen.x + area_tamano.x \
		and posicion.y >= area_origen.y and posicion.y <= area_origen.y + area_tamano.y

func _draw():
	draw_rect(Rect2(area_origen, area_tamano), Color(0, 1, 0, 0.2), true)
	draw_rect(Rect2(area_origen, area_tamano), Color(0, 1, 0), false)
	
