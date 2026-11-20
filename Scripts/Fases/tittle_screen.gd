extends Node2D

@onready var start_btn: Button = $Control/VBoxContainer/start_btn
@onready var quit_btn: Button = $Control/VBoxContainer/quit_btn
@onready var transicao: CanvasLayer = $transicao
@onready var transicao_animacao = get_node("transicao/ColorRect/animacao")
@onready var parallax_background: ParallaxBackground = $Parallax2D/ParallaxBackground

func _on_start_btn_pressed() -> void:
	transicao.visible = true
	transicao_animacao.play("transicao_in")
	await transicao_animacao.animation_finished
	get_tree().change_scene_to_file("res://Cenas/fases/mundo1/fase_1.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	parallax_background.scroll_offset.x += -100 * delta
