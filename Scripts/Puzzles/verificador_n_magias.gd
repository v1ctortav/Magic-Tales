extends Area2D

@export var valor_entrada = 0
@onready var animacao: AnimatedSprite2D = $animacao
@onready var label: Label = $Label
var ativou = false

func _ready() -> void:
	label.text = "+{n_mana}".format({"n_mana": valor_entrada})

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player_1") or area.get_parent().is_in_group("player_1"):
		if PlayersSettigns.n_magias > valor_entrada or PlayersSettigns.n_magias < valor_entrada and ativou == false:
			ativou = true
			animacao.play("negado")
			area.get_parent().movimentacao.tomar_dano()
		elif PlayersSettigns.n_magias == valor_entrada  and ativou == false:
			ativou = true
			animacao.play("liberado")
			label.text = " "
