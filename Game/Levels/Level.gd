# NIVEL
class_name Level
extends Node2D


# ATRIBUTOS ONREADY
onready var container_lasers:Node


# METODOS
func _ready() -> void:
	connect_sings()
	create_container()


# METODOS CUSTOM
func connect_sings() -> void:
	Events.connect("shot", self, "_on_shot")

func create_container() -> void:
	container_lasers = Node.new()
	container_lasers.name = "ContainerLasers"
	add_child(container_lasers)

func _on_shot(laser:Laser) -> void:
	container_lasers.add_child(laser)
