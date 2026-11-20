extends Area2D

var entidades = 0
var dentro = 0
var ja_entrou = false
var bodies_na_area: Array[CharacterBody2D] = []
var possui_chave = false
var abriu = false
@export_file_path() var prox_fase

func _unhandled_input(event: InputEvent) -> void:
	if ja_entrou == true:
		return
	if event.is_action_pressed("interagir"):
		var body = _get_body_valido()
		if body == null:
			return
		
		if PlayersSettigns.chave_saida == true and abriu == false and GameEvents.player_atual == body.nome:
			abriu = true
			GameEvents.liberar_saida.emit()
			PlayersSettigns.chave_saida = false
			return
		
		if abriu == true and GameEvents.player_atual == body.nome:
			ja_entrou = true
			dentro += 1
			
			var tween = create_tween()
			tween.tween_property(body, "modulate:a", 0, 0.25)
			await tween.finished
			
			bodies_na_area.erase(body)
			
			if body.is_in_group("player_1"):
				var p2 = get_tree().current_scene.get_node_or_null("player/player_2")
				if is_instance_valid(p2):
					GameEvents.trocou_player.emit()
					GameEvents.trocou_player2.emit()
					body.call_deferred("queue_free")
			else:
				var p1 = get_tree().current_scene.get_node_or_null("player/player_1")
				if is_instance_valid(p1):
					GameEvents.trocou_player.emit()
					GameEvents.trocou_player1.emit()
					body.call_deferred("queue_free")
			
			ja_entrou = false
			
			if dentro > 1:
				GameEvents.transicao.emit("prox_fase", prox_fase)
				PlayersSettigns.chave_saida = false
				PlayersSettigns.n_magias = 0
				PlayersSettigns.conta = 0

func _get_body_valido() -> CharacterBody2D:
	var overlapping = get_overlapping_bodies()
	for body in bodies_na_area:
		if is_instance_valid(body) and body in overlapping:
			return body
	return null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		entidades += 1
		bodies_na_area.append(body as CharacterBody2D)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		entidades -= 1
		bodies_na_area.erase(body)
