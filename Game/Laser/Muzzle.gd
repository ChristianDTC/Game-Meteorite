class_name Muzzle # CAÑON
extends Node2D


# ATRIBUTO EXPORT
export var laser:PackedScene = null
export var timing_shot:float = 0.8
export var velocity_laser:int = 100
export var damage_laser = 1


# ATRIBUTOS ONREADY
onready var timer_cooling:Timer = $TimerCooling
onready var shot_sfx: AudioStreamPlayer2D = $ShotSFX
onready var is_cooling:bool = true
onready var is_shoting:bool = false setget set_is_shoting


# ATRIBUTOS
var points_shoting:Array = []


# SETTERS Y GETTERS
func set_is_shoting(shoting:bool) -> void:
	is_shoting = shoting


# METODOS
func _ready() -> void:
	store_points_shot()
	timer_cooling.wait_time = timing_shot

func _process(delta: float) -> void:
	if is_shoting and is_cooling:
		shot()

# METODOS CUSTOM
func store_points_shot() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			points_shoting.append(nodo)

func shot() -> void:
	is_cooling = false
	shot_sfx.play()
	timer_cooling.start()
	for point_shoting in points_shoting:
		var new_laser:Laser = laser.instance()
		new_laser.create(
			point_shoting.global_position,
			get_owner().rotation,
			velocity_laser,
			damage_laser
		)
	print("piw")

func _on_TimerCooling_timeout() -> void:
	is_cooling = true
