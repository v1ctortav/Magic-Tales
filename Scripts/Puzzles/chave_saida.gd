extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		PlayersSettigns.chave_saida = true
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.25)
		await tween.finished
		call_deferred("queue_free")
