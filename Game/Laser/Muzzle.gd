class_name Muzzle # CAÑON
extends Node2D


# ATRIBUTO EXPORT
export var laser:PackedScene = null
export var timing_shot:float = 0.3
export var velocity_laser:int = 1600
export var damage_laser = 1


# ATRIBUTOS ONREADY
onready var timer_cooling:Timer = $TimerCooling
onready var shot_sfx: AudioStreamPlayer2D = $ShotSFX
onready var is_cooling:bool = true
onready var is_shoting:bool = false setget set_is_shoting
onready var can_shot:bool = false setget set_can_shot



# ATRIBUTOS
var points_shoting:Array = []


# SETTERS Y GETTERS
func set_can_shot(owner_can: bool) -> void: #dueño puede
	can_shot = owner_can

func set_is_shoting(shoting:bool) -> void:
	is_shoting = shoting


# METODOS
func _ready() -> void:
	store_points_shot()
	timer_cooling.wait_time = timing_shot

# warning-ignore:unused_argument
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
	timer_cooling.start()
	for point_shoting in points_shoting:
		shot_sfx.play()
		var new_laser:Laser = laser.instance()
		new_laser.create(
			point_shoting.global_position,
			get_owner().rotation,
			velocity_laser,
			damage_laser
			)
		Events.emit_signal("shot", new_laser)

func _on_TimerCooling_timeout() -> void:
	is_cooling = true
