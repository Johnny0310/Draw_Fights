extends Area2D

var impactos: int = 0

@onready var text_edit := $"../Impactos"
@onready var main_node := get_node("/root/game")  # Accedemos al nodo raíz 'game'


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	actualizar_texto()

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
