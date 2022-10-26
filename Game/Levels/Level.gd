extends Node2D

func _ready() -> void:
# warning-ignore:return_value_discarded
	Events.connect("shot", self, "_on_shot")

func _on_shot(laser:Laser) -> void:
	add_child(laser)
