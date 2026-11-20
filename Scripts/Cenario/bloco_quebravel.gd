extends StaticBody2D

@onready var hitbox: Area2D = $hitbox



func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("magia_destruir"):
		call_deferred("queue_free")
		area.get_parent().call_deferred("queue_free")
