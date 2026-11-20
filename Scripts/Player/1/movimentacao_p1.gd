extends Node

class_name Movimentacao_p1

@onready var animacao: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var hitbox: Area2D = $"../hitbox"

enum estados {
	idle,
	andar,
	pular,
	cair,
	empurrar,
	subir
}

var trocou = false
var movimentando = true

var corpo: CharacterBody2D
var delta: float
var velocidade: float
var aceleracao: float
var desaceleracao: float
var forca_pulo: float
var direcao: float
var contador_pulos = 0
@export var in_escada = false
@export var subindo_escada = false
const VELOCIDADE_ESCADA = 80
var knockback = Vector2(200, -200)
@onready var som_morte: AudioStreamPlayer = $"../som_morte"

var status: estados

func instanciar(corpo: CharacterBody2D, velocidade: float, aceleracao: float, desaceleracao: float, forca_pulo: float, direcao: float):
	self.corpo = corpo
	self.velocidade = velocidade
	self.aceleracao = aceleracao
	self.desaceleracao = desaceleracao
	self.forca_pulo = forca_pulo
	self.direcao = direcao

func _ready() -> void:
	GameEvents.trocou_player1.connect(mov)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("trocar"):
		var p2 = get_tree().current_scene.get_node_or_null("player/player_2")
		if is_instance_valid(p2):
			trocou = true
			GameEvents.trocou_player.emit()
			GameEvents.trocou_player2.emit()
	if status == estados.subir and trocou == true:
		go_to_cair_state()
	if corpo.is_on_floor() and trocou == true:
		go_to_idle_state()
		movimentando = false
		set_process(false)

func mov():
	set_process(true)
	movimentando = true
	trocou = false

func set_estado(delta: float):
	self.delta = delta
	
	if movimentando:
		match status:
			estados.idle:
				idle_state()
			estados.andar:
				andar_state()
			estados.pular:
				pular_state()
			estados.cair:
				cair_state()
			estados.empurrar:
				empurrar_state()
			estados.subir:
				subir_state()
	else:
		gavidade()
		corpo.velocity.x = move_toward(corpo.velocity.x, 0, desaceleracao * delta)
	
	corpo.move_and_slide()

func mover():
	atualizar_direcao()
	
	if direcao:
		corpo.velocity.x = move_toward(corpo.velocity.x, direcao * velocidade, aceleracao * delta)
	else:
		corpo.velocity.x = move_toward(corpo.velocity.x, 0, desaceleracao * delta)
func gavidade(): 
	if not corpo.is_on_floor():
		corpo.velocity += corpo.get_gravity() * delta
func atualizar_direcao():
	direcao = Input.get_axis("esquerda", "direita")
	if direcao < 0:
		animacao.flip_h = true
	elif direcao > 0:
		animacao.flip_h = false


func go_to_idle_state():
	status = estados.idle
	animacao.play("idle")
func idle_state():
	gavidade()
	mover()
	if Input.is_action_just_pressed("pular"):
		go_to_pular_state()
		return
	if corpo.velocity.x != 0:
		go_to_andar_state()
		return
	if in_escada and Input.is_action_pressed("subir") or Input.is_action_pressed("descer"):
		go_to_subir_state()
	if not corpo.is_on_floor() and corpo.velocity.y > 0:
		go_to_cair_state()
		return

func go_to_andar_state():
	status = estados.andar
	animacao.play("andar")
func andar_state():
	gavidade()
	mover()
	if corpo.velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("pular"):
		go_to_pular_state()
		return
	if in_escada and Input.is_action_pressed("subir") or in_escada and Input.is_action_pressed("descer"):
		go_to_subir_state()
	if not corpo.is_on_floor() and corpo.velocity.y > 0:
		go_to_cair_state()
		return

func go_to_pular_state():
	status = estados.pular
	animacao.play("pular")
	corpo.velocity.y = forca_pulo
	contador_pulos += 1 
func pular_state():
	gavidade()
	mover()
	
	if Input.is_action_just_pressed("pular") && contador_pulos < 1:
		go_to_pular_state()
		return
	
	if in_escada and Input.is_action_pressed("subir") or in_escada and Input.is_action_pressed("descer"):
		go_to_subir_state()
	
	if corpo.velocity.y > 0:
		go_to_cair_state()
		return

func go_to_cair_state():
	status = estados.cair
	animacao.play("cair")
func cair_state():
	gavidade()
	mover()
	
	if Input.is_action_just_pressed("pular") && contador_pulos < 1:
		go_to_pular_state()
		return
		
	if in_escada and Input.is_action_pressed("subir") or in_escada and Input.is_action_pressed("descer"):
		go_to_subir_state()
	
	if corpo.is_on_floor():
		contador_pulos = 0
		if corpo.velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_andar_state()
		return

func go_to_empurrar_state():
	status = estados.empurrar
	animacao.play("idle")
func empurrar_state():
	gavidade()
	mover()
	if corpo.velocity.x == 0:
		go_to_idle_state()
	if Input.is_action_just_pressed("pular"):
		go_to_pular_state()
		return
	if not corpo.is_on_floor() and corpo.velocity.y > 0:
		go_to_cair_state()
		return

func go_to_subir_state():
	status = estados.subir
	animacao.play("idle")
func subir_state():
	mover()
	if in_escada and Input.is_action_pressed("subir") or in_escada and Input.is_action_pressed("descer"):
		subindo_escada = true
	if not in_escada:
		subindo_escada = false 
		go_to_cair_state()
	if subindo_escada:
		corpo.velocity.y = 0
		if Input.is_action_pressed("subir"):
			corpo.velocity.y = -VELOCIDADE_ESCADA
		elif Input.is_action_pressed("descer"):
			corpo.velocity.y = VELOCIDADE_ESCADA
	else:
		gavidade()
	if movimentando == false:
		go_to_cair_state()

	if Input.is_action_pressed("pular") and not subindo_escada:
		go_to_pular_state()
		return
	
	if corpo.is_on_floor():
		go_to_idle_state()
		mover()
	
	if corpo.is_on_floor() and not in_escada and not subindo_escada:
		go_to_idle_state()
		return

func tomar_dano():
	go_to_cair_state()
	corpo.velocity = knockback
	som_morte.play()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(corpo, "velocity", Vector2.ZERO, 0.25)
	GameEvents.transicao.emit("reload", " ")
	await tween.finished
	animacao.modulate = Color(18.892, 18.892, 18.892)
	tween.stop()
	tween.tween_property(animacao, "modulate", Color(1, 1, 1), 0.25)
	animacao.pause()
	corpo.velocity = Vector2(0, 0)
	corpo.set_physics_process(false)
	PlayersSettigns.chave_saida = false
	PlayersSettigns.conta = 0
