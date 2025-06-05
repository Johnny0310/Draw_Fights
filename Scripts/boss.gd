extends Sprite2D

@export var textura_25: Texture2D
@export var textura_50: Texture2D
@export var textura_75: Texture2D
@export var textura_100: Texture2D

var impactos := 0

func _ready():
	var hitbox = get_parent().get_node("Area2D")
	if hitbox and hitbox.has_signal("impactos_actualizados"):
		hitbox.connect("impactos_actualizados", _on_impactos_actualizados)

func _on_impactos_actualizados(nuevos_impactos: int):
	impactos = nuevos_impactos
	_actualizar_textura()

func _actualizar_textura():
	if impactos >= 100 and impactos > 75:
		texture = textura_100
	elif impactos >= 75 and impactos > 50:
		texture = textura_75
	elif impactos <= 50 and impactos > 25:
		texture = textura_50
	elif impactos <= 25:
		texture = textura_25
