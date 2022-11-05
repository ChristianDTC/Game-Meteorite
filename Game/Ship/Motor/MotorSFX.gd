#MOTOR
class_name Motor
extends AudioStreamPlayer2D


export var time_transition:float = 0.6
export var volume_off:float = 8.0

onready var tween_sound:Tween = $Tween

var volume_origin:float

func _ready() -> void:
	volume_origin = volume_db
	volume_db = volume_off

func sound_on() -> void:
	if not playing:
		play()
	
	efect_transition(volume_db, volume_origin)

func sound_off() -> void:
	efect_transition(volume_db, volume_off)

func efect_transition(from_vol: float, to_vol: float) -> void:
	tween_sound.interpolate_property(
		self,
		"volume_db",
		from_vol,
		to_vol,
		time_transition,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween_sound.start()
