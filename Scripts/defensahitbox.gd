extends RigidBody2D

var tipo = 2  # 1 = Ataque | 2 = Defensa | 3 = Tinta Roca
var player = true

func _ready():
	# Asegúrate de que el nodo tenga activada la señal de contacto
	contact_monitor = true
	max_contacts_reported = 1000  # Puedes ajustar este valor según tus necesidades

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider is RigidBody2D and collider.has_method("get_tipo"):
			if collider.get_tipo() != tipo:
				queue_free()



func get_tipo():
	return tipo
