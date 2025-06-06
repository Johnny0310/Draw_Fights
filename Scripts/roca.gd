extends StaticBody2D

var tipo = 3  # 1 = Ataque | 2 = Defensa | 3 = Tinta Roca 
var dureza = 0.5
var is_frozen := true
var player = true
var yasubi = false

func _ready():
	# Asegúrate de tener un CollisionShape2D y un Area2D como hijo para detectar colisiones
	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.has_method("get_tipo") and body.player == false:
		print(dureza)
		if body.get_tipo() == 1:
			body.choque_roca = true
			dureza -= 1
		elif body.get_tipo() == 2:
			body.queue_free()
			dureza -= 0.5
		
		if dureza <= 0:
				print(dureza)
				queue_free()
				
	
	if body is RigidBody2D and body.has_method("get_tipo") and body.player == true:
		print("Soy Roca")
		if body.get_tipo() == 1:
			body.choque_roca = true
			dureza -= 1
		elif body.get_tipo() == 2:
			body.queue_free()
			dureza -= 0.5
		if dureza <= 0:
			print(dureza)
			queue_free()



func get_tipo():
	return tipo
