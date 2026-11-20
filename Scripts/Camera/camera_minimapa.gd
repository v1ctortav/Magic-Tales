extends Camera2D

var alvo: Node2D = null
var proximo_grupo: String = "player_2"
@export var zoom_level: float = 5.0

func _ready():
	zoom = Vector2(1.0 / zoom_level, 1.0 / zoom_level)
	_buscar_alvo("player_1")
	GameEvents.trocou_player.connect(_trocar_alvo)
	GameEvents.player_atual = "player_1"

func _physics_process(delta: float) -> void:
	if alvo != null and is_instance_valid(alvo):
		global_position = alvo.global_position

func _buscar_alvo(grupo: String) -> void:
	var nodes = get_tree().get_nodes_in_group(grupo)
	if nodes.size() > 0:
		alvo = nodes[0]

var tween: Tween

func _trocar_alvo() -> void:
	_buscar_alvo(proximo_grupo)
	if proximo_grupo == "player_2":
		proximo_grupo = "player_1"
		GameEvents.player_atual = "player_2"
	else:
		proximo_grupo = "player_2"
		GameEvents.player_atual = "player_1"
