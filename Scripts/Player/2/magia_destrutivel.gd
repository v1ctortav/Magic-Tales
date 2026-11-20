extends CharacterBody2D

@onready var tempo_sumir: Timer = $tempo_sumir
@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
var velocidade = 40
var direcao := Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity = direcao * velocidade
	if velocidade < 120:
		velocidade += 40 * delta
	look_at(global_position + direcao)
	move_and_slide()
	await animacao.animation_finished
	animacao.play("movimentando")

func _on_tempo_sumir_timeout() -> void:
	call_deferred("queue_free")
