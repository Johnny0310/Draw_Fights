extends Area2D

var impactos: int = 0

@onready var text_edit := $"../Impactos"
@onready var text_edit_ammo := $"../Ammo"
@onready var main_node := get_node("/root/game")  # Accedemos al nodo raíz 'game'

# Escenas a instanciar
@export var ataque_scene: PackedScene
@export var defensa_scene: PackedScene

# Rango de tiempo aleatorio entre invocaciones (en segundos)
var tiempo_minimo: float = 1.0

var tiempo_maximo: float = 4.0

# Nodo donde se añadirán las instancias
@export var nodo_contenedor: NodePath = "."
@onready var collision_shape := $CollisionShape2D


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	actualizar_texto()
	invocar_aleatorio()

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		impactos += 1
		print("Impactado por:", body.name, "- Total impactos:", impactos)
		if body.is_inside_tree():
			body.queue_free()
		actualizar_texto()

func actualizar_texto() -> void:
	if text_edit and text_edit is TextEdit:
		text_edit.text = "Impactos: %d" % impactos

	if text_edit_ammo and text_edit_ammo is TextEdit:
		text_edit_ammo.text = "Ammo: %d" % main_node.ammo

func invocar_aleatorio() -> void:
	var tiempo_random = randf_range(tiempo_minimo, tiempo_maximo)
	await get_tree().create_timer(tiempo_random).timeout

	var tipo = randi_range(1, 2)
	var bala: Node
	randomize()  # Para que los valores cambien en cada ejecución
	var limite = int(randf_range(3, 9))  # randf_range(3, 9) genera un float entre 3 y 9 (excluye 9)
	for i in range(limite):
		if tipo == 1:
			bala = load("res://Scenes/ataque.tscn").instantiate()
		elif tipo == 2:
			bala = load("res://Scenes/defensa.tscn").instantiate()
		# Asignar posición aleatoria en X entre 100 y 1180, Y fijo en 180
		var posicion_aleatoria = Vector2(randf_range(200.0, 1080.0), 195.0)
		bala.position = posicion_aleatoria
		bala.gravity_scale = 1
		var contenedor = get_node(nodo_contenedor)
		contenedor.add_child(bala)
		
	invocar_aleatorio()
