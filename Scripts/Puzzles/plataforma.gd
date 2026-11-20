extends AnimatableBody2D

@onready var alvo: Sprite2D = $alvo

var ativou = false
var is_ativado = false
var posicao_original: Vector2
var tween: Tween

func _ready() -> void:
	alvo.visible = false
	posicao_original = global_position

func ativado():
	if ativou: return
	ativou = true
	is_ativado = true
	mover_plataforma(alvo.global_position, 2)

func desativado():
	if !ativou: return
	ativou = false
	is_ativado = false
	mover_plataforma(posicao_original, 1)

func trocar_estado():
	if ativou == false:
		ativado()
	else:
		desativado()
	

func mover_plataforma(destino: Vector2, velocidade: float):
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", destino, velocidade)
