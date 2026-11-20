extends StaticBody2D

@onready var tempo_voltar: Timer = $tempo_voltar
@onready var animacao: AnimatedSprite2D = $animacao
@onready var colisao: Area2D = $colisao

enum Estado { NORMAL, QUEBRANDO, QUEBRADO, VOLTANDO }
var estado: Estado = Estado.NORMAL

func _ready() -> void:
	pass

func _on_colisao_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_1") and estado == Estado.NORMAL:
		_quebrar()

func _quebrar() -> void:
	estado = Estado.QUEBRANDO
	animacao.play("quebrar")

func _on_animacao_animation_finished() -> void:
	if estado == Estado.QUEBRANDO:
		estado = Estado.QUEBRADO
		visible = false
		modulate.a = 0
		set_collision_layer_value(3, false)
		colisao.set_collision_layer_value(3, false)
		tempo_voltar.start()

func _on_tempo_voltar_timeout() -> void:
	estado = Estado.VOLTANDO
	visible = true
	animacao.play("normal")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5)
	tween.finished.connect(_on_tween_voltou)

func _on_tween_voltou() -> void:
	set_collision_layer_value(3, true)
	colisao.set_collision_layer_value(3, true)
	estado = Estado.NORMAL
