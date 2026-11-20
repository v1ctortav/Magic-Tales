extends Node2D

@onready var play_aguain_btn: Button = $Control/VBoxContainer/play_aguain_btn
@onready var quit_btn: Button = $Control/VBoxContainer/quit_btn
@onready var transicao: CanvasLayer = $transicao
@onready var transicao_animacao = get_node("transicao/ColorRect/animacao")
@onready var tempo_jogo: Label = $tempo_jogo
@onready var parallax_background: ParallaxBackground = $Parallax2D/ParallaxBackground

var segundos_jogo = 0
var minutos_jogo = 0

func _ready() -> void:
	minutos_jogo = int(Global.tempo_jogo) / 60
	segundos_jogo = int(Global.tempo_jogo) % 60
	tempo_jogo.text = "%02d:%02d" % [minutos_jogo, segundos_jogo]

func _process(delta: float) -> void:
	parallax_background.scroll_offset.x += -100 * delta

func _on_quit_btn_pressed() -> void:
	transicao.visible = true
	transicao_animacao.play("transicao_in")
	await transicao_animacao.animation_finished
	get_tree().change_scene_to_file("res://Cenas/tittle_screen.tscn")

func _on_play_aguain_btn_pressed() -> void:
	transicao.visible = true
	transicao_animacao.play("transicao_in")
	await transicao_animacao.animation_finished
	get_tree().change_scene_to_file("res://Cenas/fases/mundo1/fase_1.tscn")
	Global.tempo_jogo = 0
	PlayersSettigns.chave_saida = false
	PlayersSettigns.n_magias = 0
	PlayersSettigns.conta = 0
