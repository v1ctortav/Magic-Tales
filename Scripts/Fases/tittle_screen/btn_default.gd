extends Button

var tween: Tween
@onready var fundo: Sprite2D = $Sprite2D

func _on_mouse_entered() -> void:
	tween = create_tween()
	tween.tween_property(fundo, "modulate:a", 1, 0.25)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_mouse_exited() -> void:
	tween = create_tween()
	tween.tween_property(fundo, "modulate:a", 0, 0.25)
