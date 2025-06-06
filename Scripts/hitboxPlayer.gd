class_name PlayerHitBox extends Area2D

var impactos: int = 0
var impactosDef = 0

@onready var text_edit := $"../Impactos"
@onready var main_node := get_node("/root/game")  # Accedemos al nodo raíz 'game'


# Variables para la barra de salud y tinta
@export var barra_vida : BarraSalud
@export var barra_tinta : BarraSalud
var salud_maxima = 200
var tinta_maxima

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	tinta_maxima = main_node.ammo
	actualizar_texto()
	actualizar_salud()
	actualizar_tinta()

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
		print("Impactado por:", body.name, "- Total impactos:", impactos)
		if body.is_inside_tree():
			body.queue_free()
		actualizar_texto()
		actualizar_salud()

func actualizar_texto() -> void:
	if text_edit and text_edit is TextEdit:
		text_edit.text = "Impactos: %d" % impactos


func actualizar_salud():
	if barra_vida:
		barra_vida.actualizar_barra(salud_maxima, impactos)

func actualizar_tinta():
	if barra_tinta:
		barra_tinta.actualizar_barra(tinta_maxima, main_node.ammo)
