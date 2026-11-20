extends Area2D

var corpos_dentro: Array = []
var pode_entrar = true

@export var alvo: Node2D

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interagir"):
		return
	if not pode_entrar or alvo == null:
		return

	var body = _get_body_do_jogador_atual()
	if body == null:
		return

	pode_entrar = false
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(body, "modulate:a", 0, 0.25)
	await tween.finished
	tween.stop()
	body.global_position = alvo.global_position
	tween.play()
	tween.tween_property(body, "modulate:a", 1, 0.25)
	await tween.finished
	pode_entrar = true

func _get_body_do_jogador_atual() -> CharacterBody2D:
	for b in corpos_dentro:
		if is_instance_valid(b) and b.get("nome") == GameEvents.player_atual:
			return b
	return null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		if body not in corpos_dentro:
			corpos_dentro.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_1") or body.is_in_group("player_2"):
		corpos_dentro.erase(body)
