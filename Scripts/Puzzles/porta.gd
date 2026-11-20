extends StaticBody2D

@onready var animacao: AnimatedSprite2D = $animacao
@onready var colisao: CollisionShape2D = $CollisionShape2D

@export_enum("aberto", "fechado") var estado = "fechado" 

var is_aberta = false
var is_ativado = false

func _ready() -> void:
	if estado == "aberto":
		ativado()
		return

func _process(delta: float) -> void:
	if is_aberta:
		colisao.disabled = true
	else:
		colisao.disabled = false

func ativado():
	animacao.play("abrir")
	is_aberta = true
	is_ativado = true

func desativado():
	animacao.play("fechar")
	await animacao.animation_finished
	is_aberta = false
	is_ativado = false
	animacao.play("fechada")

func trocar_estado():
	if is_aberta == false:
		ativado()
	else:
		desativado()
	
