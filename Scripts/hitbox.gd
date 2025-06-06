extends Area2D

var impactos: int = 0
var impactosDef: float = 0
var tiposDeBala = 3

# Variables del Spam de los ataques, defensas, etc
var rangoX_Menor = 200 # Default 210
var rangoX_Mayor = 850 # Default 840
var rangoY_menor = 195 # Default 195
var rangoY_mayor = 400 # Default 195

# Rango de tiempo aleatorio entre invocaciones (en segundos)
var tiempo_minimo: float = 1.0
var gravedad_ataque = 1
var gravedad_defensa = 0.25

var tiempo_maximo: float = 4.0

# Nodo donde se añadirán las instancias
@export var nodo_contenedor: NodePath = "."
@onready var collision_shape := $CollisionShape2D


# Variables para la barra de salud y tinta
@export var barra_vida : BarraSalud
@export var barra_ulti : BarraSalud
var salud_maxima = 200
var conteo_ulti = 0


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	invocar_aleatorio()
	actualizar_salud()
	actualizar_ulti()

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.has_method("get_tipo") and body.has_method("get_choque_roca"):
		if body.get_tipo() == 1:
			if !body.get_choque_roca():
				impactos += 1
			else:
				impactos += 0.5
		elif body.get_tipo() == 2:
			print("choque")
			impactosDef += 0.25
			if impactosDef == 1:
				impactos += 1
				print(impactosDef)
				impactosDef = 0
		
		if body.is_inside_tree():
			body.queue_free()
		actualizar_salud()

func invocar_aleatorio() -> void:
	var tiempo_random = randf_range(tiempo_minimo, tiempo_maximo)
	await get_tree().create_timer(tiempo_random).timeout

	var tipo = randi_range(1, tiposDeBala) # ramdon del tipo de bala
	var bala: Node
	randomize()  # Para que los valores cambien en cada ejecución
	var limite = int(randf_range(3, 9))  # randf_range(3, 9) genera un float entre 3 y 9 (excluye 9)
	for i in range(limite):
		if tipo == 1:
			bala = load("res://Scenes/ataque.tscn").instantiate()
			bala.player = false
			bala.gravity_scale = gravedad_ataque
			bala.set_collision_layer(1)  # Solo capa 1
			bala.set_collision_mask(2)  # Solo mask 1
		elif tipo == 2:
			bala = load("res://Scenes/defensa.tscn").instantiate()
			bala.player = false
			bala.gravity_scale = gravedad_defensa
			bala.set_collision_layer(1)  # Solo capa 1
			bala.set_collision_mask(2)  # Solo mask 1
		elif tipo == 3:
			bala = load("res://Scenes/roca.tscn").instantiate()
			bala.player = false
			bala.set_collision_layer(2)  # Solo capa 1
			bala.set_collision_mask(2)  # Solo mask 1
		# Asignar posición aleatoria en X entre 100 y 1180, Y fijo en 180
		var randomX = randf_range(rangoX_Menor, rangoX_Mayor)
		var randomY = randf_range(rangoY_menor, rangoY_mayor)
		var posicion_aleatoria = Vector2(randomX, randomY)
		bala.position = posicion_aleatoria
		var contenedor = get_node(nodo_contenedor)
		contenedor.add_child(bala)
		
	conteo_ulti += 1
	print(conteo_ulti)
	
	
	if conteo_ulti == 4:
		conteo_ulti = 0
	actualizar_ulti()
	
	
	invocar_aleatorio()

func actualizar_salud():
	if barra_vida:
		barra_vida.actualizar_barra(salud_maxima, impactos)

func actualizar_ulti():
	if barra_ulti:
		barra_ulti.actualizar_barra(3, conteo_ulti)
