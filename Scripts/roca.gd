extends StaticBody2D

var tipo = 3  # 1 = Ataque | 2 = Defensa | 3 = Tinta Roca 
var dureza = 2
var is_frozen := true
var player = true

func _ready():
	# Asegúrate de tener un CollisionShape2D y un Area2D como hijo para detectar colisiones
	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_entered", Callable(self, "_on_body_entered_player"))

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.has_method("get_tipo") and body.player == false:
		print(dureza)
		if body.get_tipo() != tipo:
			body.queue_free()
			dureza -= 1
			if dureza == 0:
				print(dureza)
				queue_free()

func _on_body_entered_player(body: Node) -> void:
	if body is RigidBody2D and body.has_method("get_tipo") and body.player == true:
		body.set_collision_layer(2)  # Solo capa 2
		body.set_collision_mask(1)  # Solo mask 2


func get_tipo():
	return tipo
