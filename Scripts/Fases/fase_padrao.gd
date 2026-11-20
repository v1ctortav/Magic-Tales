extends Node2D

@onready var transicao: CanvasLayer = $transicao
@onready var transicao_animacao = get_node("transicao/ColorRect/animacao")
@onready var portao_final: AnimatedSprite2D = $mapa/portao_final
@onready var pause_menu: CanvasLayer = $pause_menu
@onready var timer_fase: Timer = $timer_fase
@onready var musica: AudioStreamPlayer = $musica
var portao_aberto = false

func _ready() -> void:
	GameEvents.transicao.connect(set_transicao)
	GameEvents.liberar_saida.connect(abrir_portao)
	transicao.visible = true
	transicao_animacao.play("transicao_out")
	await transicao_animacao.animation_finished
	transicao.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("sair"):
		var tween = create_tween()
		tween.set_parallel(true)
		pause_menu.show()
		tween.tween_property(pause_menu.control, "modulate:a", 1, 0.25)
		tween.tween_property(pause_menu.fundo, "modulate:a", 0.8, 0.25)
		await tween.finished
		timer_fase.paused = true
		musica.stream_paused = true
		get_tree().paused = true
		return

func set_transicao(tipo, prox_fase):
	if tipo == "reload":
		var tree = get_tree()
		timer_fase.paused = true
		transicao.visible = true
		transicao_animacao.play("transicao_in")
		await transicao_animacao.animation_finished
		if tree.current_scene != null:
			tree.reload_current_scene()
		else:
			tree.change_scene_to_file(scene_file_path)
	if tipo == "prox_fase":
		var tree = get_tree()
		timer_fase.paused = true
		transicao.visible = true
		transicao_animacao.play("transicao_in")
		await transicao_animacao.animation_finished
		tree.change_scene_to_file(prox_fase)
func abrir_portao():
	if portao_aberto == false:
		portao_final.play("abrir")
		portao_aberto = true

func _on_timer_fase_timeout() -> void:
	Global.tempo_jogo += 1
