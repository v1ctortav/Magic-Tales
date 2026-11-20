extends CanvasLayer

var player_atual = "player_1"
@onready var animacao_magia: AnimatedSprite2D = $magia
@onready var chave: AnimatedSprite2D = $chave
@onready var h_1: Sprite2D = $h1
@onready var h_2: Sprite2D = $h2
@onready var head: Sprite2D = $head
@onready var magia: AnimatedSprite2D = $magia
@onready var sub_viewport: SubViewport = $SubViewport
@onready var minimapa: TextureRect = $minimapa
@onready var camera: Camera2D = $SubViewport/camera
@onready var conta_valor: Label = $conta_valor
@onready var tempo_jogo: Label = $tempo_jogo

var segundos_jogo = 0
var minutos_jogo = 0

func _ready() -> void:
	trocar_hud()
	GameEvents.trocou_player.connect(trocar_hud)
	minimapa.texture = sub_viewport.get_texture()
	sub_viewport.world_2d = get_tree().current_scene.get_viewport().world_2d
	camera.limit_left = get_tree().current_scene.get_node("player/camera").limit_left
	camera.limit_right = get_tree().current_scene.get_node("player/camera").limit_right
	camera.limit_bottom = get_tree().current_scene.get_node("player/camera").limit_bottom
	camera.limit_top = get_tree().current_scene.get_node("player/camera").limit_top

func _process(delta: float) -> void:
	if PlayersSettigns.chave_saida == true:
		chave.modulate.a = 1
	else:
		chave.modulate.a = 0.5
	animacao_magia.play("{n_magias}".format({"n_magias": PlayersSettigns.n_magias}))
	if PlayersSettigns.conta > 0:
		conta_valor.text = "+{valor}".format({"valor": PlayersSettigns.conta})
	elif PlayersSettigns.conta < 0:
		conta_valor.text = "{valor}".format({"valor": PlayersSettigns.conta})
	elif PlayersSettigns.conta == 0:
		conta_valor.text = "{valor}".format({"valor": PlayersSettigns.conta})

	if Global.tempo_jogo > 0:
		minutos_jogo = int(Global.tempo_jogo) / 60
		segundos_jogo = int(Global.tempo_jogo) % 60
		tempo_jogo.text = "%02d:%02d" % [minutos_jogo, segundos_jogo]

func trocar_hud():
	var tween = create_tween()
	tween.set_parallel(true)
	if GameEvents.player_atual == "player_1":
		tween.tween_property(h_1, "modulate:a", 1, 0.25)
		tween.tween_property(head, "modulate:a", 1, 0.25)
		h_2.modulate.a = 0
		magia.modulate.a = 0
	else:
		tween.tween_property(h_2, "modulate:a", 1, 0.25)
		tween.tween_property(magia, "modulate:a", 1, 0.25)
		h_1.modulate.a = 0
		head.modulate.a = 0
