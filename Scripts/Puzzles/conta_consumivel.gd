extends Area2D

@export var valor = 0
@export_enum ("som", "sub", "mul", "div") var tipo = "som"
@onready var label: Label = $Label

func _ready() -> void:
	if tipo == "som":
		label.text = "+{valor}".format({"valor": valor})
		label.add_theme_color_override("font_color", Color(0.0, 0.577, 0.945, 1.0))
	elif tipo == "sub":
		label.text = "-{valor}".format({"valor": valor})
		label.add_theme_color_override("font_color", Color(1, 0, 0))
	elif tipo == "mul":
		label.text = "x{valor}".format({"valor": valor})
		label.add_theme_color_override("font_color", Color(0.0, 0.577, 0.945, 1.0))
	else:
		label.text = "/{valor}".format({"valor": valor})
		label.add_theme_color_override("font_color", Color(1, 0, 0))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		if tipo == "som":
			PlayersSettigns.conta += valor
		elif tipo == "sub":
			PlayersSettigns.conta -= valor
		elif tipo == "mul":
			PlayersSettigns.conta *= valor
		else:
			PlayersSettigns.conta /= valor
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.25)
		await tween.finished
		call_deferred("queue_free")
