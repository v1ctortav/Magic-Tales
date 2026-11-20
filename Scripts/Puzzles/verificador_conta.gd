extends Area2D

@export var valor_entrada = 0
@export_enum("pos", "neg") var sinal = "pos"
@onready var animacao: AnimatedSprite2D = $animacao
@onready var label: Label = $Label

func _ready() -> void:
	if sinal == "pos":
		label.text = "+{valor}".format({"valor": valor_entrada})
	else:
		label.text = "-{valor}".format({"valor": valor_entrada})
		valor_entrada *= -1

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player_1") or area.get_parent().is_in_group("player_2"):
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		if PlayersSettigns.conta != valor_entrada:
			animacao.play("negado")
			area.get_parent().movimentacao.tomar_dano()
		if PlayersSettigns.conta == valor_entrada:
			animacao.play("liberado")
			label.text = "OK"
