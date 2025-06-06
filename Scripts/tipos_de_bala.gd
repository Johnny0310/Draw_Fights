extends Node2D

@onready var sprite = $Sprite2D
@onready var btn_ataque = $Ataque
@onready var btn_defensa = $Defensa
@onready var btn_roca = $Roca
@onready var main_node := get_node("/root/game")  # Accedemos al nodo raíz 'game'

var rojo = preload("res://Sprites/enemy15x15.png")
var verde = preload("res://Sprites/pixel15.png")
var roca = preload("res://Sprites/roca15x15.png")

func _ready():
	btn_ataque.pressed.connect(_on_ataque_pressed)
	btn_defensa.pressed.connect(_on_defensa_pressed)
	btn_roca.pressed.connect(_on_roca_pressed)

func _on_ataque_pressed():
	sprite.texture = rojo
	main_node.tipoDeBala = "res://Scenes/ataque.tscn"

func _on_defensa_pressed():
	sprite.texture = verde
	main_node.tipoDeBala = "res://Scenes/defensa.tscn"
	
func _on_roca_pressed():
	sprite.texture = roca
	main_node.tipoDeBala = "res://Scenes/roca.tscn"
