extends Area2D

@export var alvos: Array[Node2D] = []

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D

var entidades = 0
var is_ativada = false
var body: CharacterBody2D

func percorrer_alvos():
	for alvo in alvos:
		if alvo != null:
			alvo.trocar_estado()

func _unhandled_key_input(event: InputEvent) -> void:
	if entidades > 0 and is_ativada == false and event.is_action_pressed("interagir") and GameEvents.player_atual == body.nome:
		is_ativada = true
		animacao.play("ligar")
		percorrer_alvos()
		await animacao.animation_finished
		animacao.play("ligado")
		return
	if entidades > 0 and is_ativada == true and event.is_action_pressed("interagir") and GameEvents.player_atual == body.nome:
		is_ativada = false
		animacao.play("desligar")
		percorrer_alvos()
		await animacao.animation_finished
		animacao.play("desligado")
		return

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		entidades += 1
		self.body = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		entidades -= 1
