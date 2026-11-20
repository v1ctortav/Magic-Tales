extends CharacterBody2D

@export var velocidade_empurrar: float = 35

@onready var detector_player_esquerda: RayCast2D = $detector_player_esquerda
@onready var detector_player_direita: RayCast2D = $detector_player_direita

var peso = 50
var corpo: CharacterBody2D
var corpo_velocidade: float

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direcao = 0
	
	if not is_on_floor():
		velocity.y += 980 * delta
	else:
		velocity.y = 0
	
	if detector_player_direita.is_colliding():
		direcao = -1
		corpo = detector_player_direita.get_collider()
		corpo.movimentacao.velocidade = velocidade_empurrar
	else:
		if corpo != null:
			corpo.movimentacao.velocidade = corpo.velocidade
	if detector_player_esquerda.is_colliding():
		direcao = 1
		corpo = detector_player_esquerda.get_collider()
		corpo.movimentacao.velocidade = velocidade_empurrar
	else:
		if corpo != null:
			corpo.movimentacao.velocidade = corpo.velocidade
	velocity.x = direcao * velocidade_empurrar
	
	move_and_slide()
