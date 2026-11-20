extends CanvasLayer

@onready var control: Control = $Control
@onready var fundo: Sprite2D = $fundo
@onready var transicao: CanvasLayer = $transicao
@onready var transicao_animacao = get_node("transicao/ColorRect/animacao")
@onready var timer_fase = get_node("../timer_fase")
@onready var musica = get_node("../musica")

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("sair"):
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(control, "modulate:a", 0, 0.25)
		tween.tween_property(fundo, "modulate:a", 0, 0.25)
		await tween.finished
		hide()
		get_tree().paused = false
		timer_fase.paused = false
		musica.stream_paused = false
		return

func _on_return_btn_pressed() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(control, "modulate:a", 0, 0.25)
	tween.tween_property(fundo, "modulate:a", 0, 0.25)
	await tween.finished
	hide()
	get_tree().paused = false
	timer_fase.paused = false
	musica.stream_paused = true
	return

func _on_reset_btn_pressed() -> void:
	var tree = get_tree()
	transicao.visible = true
	transicao_animacao.play("transicao_in")
	await transicao_animacao.animation_finished
	if tree.current_scene != null:
		get_tree().paused = false
		PlayersSettigns.chave_saida = false
		PlayersSettigns.n_magias = 0
		PlayersSettigns.conta = 0
		tree.reload_current_scene()
	else:
		get_tree().paused = false
		tree.change_scene_to_file(scene_file_path)
	hide()
	timer_fase.paused = false
	return


func _on_quit_btn_pressed() -> void:
	var tree = get_tree()
	transicao.visible = true
	transicao_animacao.play("transicao_in")
	await transicao_animacao.animation_finished
	get_tree().paused = false
	PlayersSettigns.chave_saida = false
	PlayersSettigns.n_magias = 0
	PlayersSettigns.conta = 0
	tree.change_scene_to_file("res://Cenas/tittle_screen.tscn")
	Global.tempo_jogo = 0
	return
