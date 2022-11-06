# NIVEL
class_name Level
extends Node2D


# ATRIBUTOS ONREADY
onready var container_lasers:Node


#ATRIBUTOS EXPORT
export var explosion:PackedScene = null


# METODOS
func _ready() -> void:
	connect_sings()
	create_container()


# METODOS CUSTOM
func connect_sings() -> void:
	Events.connect("shot", self, "_on_shot")
	Events.connect("ship_destroyed", self, "_on_ship_destroyed")

func create_container() -> void:
	container_lasers = Node.new()
	container_lasers.name = "ContainerLasers"
	add_child(container_lasers)

func _on_shot(laser:Laser) -> void:
	container_lasers.add_child(laser)

func _on_ship_destroyed(position: Vector2, num_explosions: int) -> void:
	for i in range(num_explosions):
		var new_explosion:Node2D = explosion.instance()
		new_explosion.global_position = position
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6), "timeout")
