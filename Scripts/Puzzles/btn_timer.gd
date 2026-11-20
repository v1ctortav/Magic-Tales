extends Area2D

@export var alvos: Array[Node2D] = []
@onready var contador: Timer = $contador
@onready var animacao: AnimatedSprite2D = $animacao

var is_ativado = false
var entidades = 1

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if entidades > 0 and !is_ativado and Input.is_action_just_pressed("interagir"):
		is_ativado = true
		percorrer_alvos()
		animacao.play("pressionado")
		contador.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ativadores"):
		entidades += 1

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("ativadores"):
		entidades -= 1

func percorrer_alvos():
	for alvo in alvos:
		if alvo != null:
			alvo.trocar_estado()

func _on_contador_timeout() -> void:
	is_ativado = false
	animacao.play("normal")
	percorrer_alvos()
