extends CharacterBody2D

@onready var movimentacao: Movimentacao_p1 = $movimentacao

var velocidade = 160
var aceleracao = 800
var desaceleracao = 800
var forca_pulo = -350
var direcao = 0
var peso = 100
var nome = "player_1"

func _ready() -> void:
	movimentacao.instanciar(self, velocidade, aceleracao, desaceleracao, forca_pulo, direcao)
	movimentacao.go_to_idle_state()

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	movimentacao.set_estado(delta)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("area_letal"):
		movimentacao.tomar_dano()
