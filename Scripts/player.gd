extends Node2D

var clic_presionado := false
var intervalo := 0.001
var tiempo_transcurrido := 0.0
var distancia_minima := 15
var balas := []
var ammo = 1000

var costo_ataque = 5
var costo_defensa = 0.25
var costo_roca = 15
var gravedad_ataque = -1
var gravedad_defensa = -0.25

var tipoDeBala = "res://Scenes/ataque.tscn"
@onready var playerHitbox := get_node("/root/game/PlayerHitBox/Area2D")  # Accedemos al nodo 'PlayerHitbox'


# Define el origen del área válida (puedes mover esto donde desees)
var area_origen := Vector2(200, 900)
var area_tamano := Vector2(500, 200)
var balaposition = Vector2()

func _ready():
	get_tree().root.print_tree_pretty()

func _input2(event):
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
						if bala != StaticBody2D:
							if bala.tipo != 3:
								bala.gravity_scale = -1

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			print("🟢 Dedo PRESIONADO en: ", event.position, " | índice: ", event.index)
			clic_presionado = true
			balaposition = Vector2(event.position)
		else:
			print("🔴 Dedo LEVANTADO en: ", event.position, " | índice: ", event.index)
			print("Botón izquierdo soltado")
			clic_presionado = false
			for bala in balas:
				if bala and bala.is_inside_tree():
					if bala != StaticBody2D:
						if bala.tipo == 3:
							if !bala.yasubi:
								bala.position = Vector2(bala.position.x, bala.position.y - 200)
								bala.yasubi = true
						elif bala.tipo == 2:
							bala.gravity_scale = gravedad_defensa
						elif bala.tipo == 1:
							bala.gravity_scale = gravedad_ataque
			balaposition = Vector2()
			playerHitbox.actualizar_tinta()
	elif event is InputEventScreenDrag:
		print("🟡 Arrastrando dedo en: ", event.position, " | índice: ", event.index)
		balaposition = Vector2(event.position)

func _process(delta):
	var area2d = get_node("EnemyHitbox/Area2D")
	
	if clic_presionado and ammo >= 0:
		tiempo_transcurrido += delta
		if tiempo_transcurrido >= intervalo:
			tiempo_transcurrido = 0.0
			var mouse_pos = get_viewport().get_mouse_position()

			if esta_en_area_valida(mouse_pos) and not hay_escena_cercana(mouse_pos):
				var bala = load(tipoDeBala).instantiate()
				bala.player = true
				bala.set_collision_layer(2)  # Solo capa 2
				bala.set_collision_mask(1)  # Solo mask 2
				bala.player = true
				bala.position = mouse_pos
				bala.position = balaposition
				add_child(bala)
				if bala.tipo == 1:
					ammo -= costo_ataque
				elif bala.tipo == 2:
					ammo -= costo_defensa
				elif bala.tipo == 3:
					ammo -= costo_roca
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
	
