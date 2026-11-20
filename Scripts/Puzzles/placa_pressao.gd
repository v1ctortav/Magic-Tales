extends StaticBody2D

@export var alvos: Array[Node2D] = []
@onready var hitbox: Area2D = $hitbox
@onready var animacao: AnimatedSprite2D = $animacao
@onready var contador: Sprite2D = $contador
@onready var contador_peso: Label = $contador/contador_peso
@export var peso_placa = 0

var corpos_na_placa: Dictionary = {}
var estava_ativada = false
var tween: Tween

func _ready() -> void:
	_atualizar_contador()

func _physics_process(_delta: float) -> void:
	var corpos_para_remover = []
	for corpo in corpos_na_placa.keys():
		if not is_instance_valid(corpo) or not hitbox.overlaps_body(corpo):
			corpos_para_remover.append(corpo)
	if not corpos_para_remover.is_empty():
		for corpo in corpos_para_remover:
			corpos_na_placa.erase(corpo)
		_recalcular()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("ativadores"):
		corpos_na_placa[body] = body.peso
		_recalcular()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("ativadores"):
		corpos_na_placa.erase(body)
		_recalcular()

func _recalcular() -> void:
	var peso_atual = _get_peso_total()
	var entidades_atual = _get_entidades()
	var deve_estar_ativa = (peso_atual == peso_placa and entidades_atual > 0)

	# Animação reflete sempre o estado real, independente de mudança
	if deve_estar_ativa:
		animacao.play("pressionada")
	else:
		animacao.play("normal")

	# Contador
	_atualizar_contador()
	if entidades_atual > 0:
		_mostrar_contador()
	else:
		_esconder_contador()

	# Só notifica alvos se o estado mudou de fato
	if deve_estar_ativa != estava_ativada:
		estava_ativada = deve_estar_ativa
		percorrer_alvos()

func _get_peso_total() -> int:
	var total = 0
	for p in corpos_na_placa.values():
		total += p
	return total

func _get_entidades() -> int:
	return corpos_na_placa.size()

func _atualizar_contador() -> void:
	contador_peso.text = "{peso}/{peso_placa}".format({
		"peso": _get_peso_total(),
		"peso_placa": peso_placa
	})

func _mostrar_contador() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(contador, "modulate:a", 1, 0.2)

func _esconder_contador() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(contador, "modulate:a", 0, 1)

func percorrer_alvos() -> void:
	for alvo in alvos:
		if alvo != null:
			alvo.trocar_estado()
