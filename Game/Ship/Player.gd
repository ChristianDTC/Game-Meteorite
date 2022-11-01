#JUGADOR
class_name Player
extends RigidBody2D


# ATRIBUTOS EXPORT
export var power_engine:int = 20 #potencia del motor
export var power_rotation:int = 280 #potencia de rotación
export var trail_max:int = 30 #estela máxima

# ATRIBUTOS
var push:Vector2 = Vector2.ZERO
var direction_rotation:int = 0


# ATRIBUTOS ONREADY
onready var muzzle:Muzzle = $Muzzle
onready var laser_beam:LaserBeam2D = $LaserBeam2D
onready var trail:Trail = $TrainPoint/Trail2D

# METODOS
func _unhandled_input(event: InputEvent) -> void:
	#DISPARO RAYO
	if event.is_action_pressed("shot_secondary"):
		laser_beam.set_is_casting(true)
	if event.is_action_released("shot_secondary"):
		laser_beam.set_is_casting(false)
	
	#CONTROL ESTELA
	if event.is_action_pressed("move_up"):
		trail.set_max_points(trail_max)
	elif event.is_action_pressed("move_down"):
		trail.set_max_points(0)
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(push.rotated(rotation))
	apply_torque_impulse(direction_rotation * power_rotation)

func _process(delta: float) -> void:
	player_input()

# METODOS CUSTOM
func player_input() -> void:
	# EMPUJE
	push = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		push = Vector2(power_engine, 0)
	elif Input.is_action_pressed("move_down"):
		push = Vector2(-power_engine, 0)

	# ROTACION
	direction_rotation = 0
	if Input.is_action_pressed("rotate_left"):
		direction_rotation -= 1
	elif Input.is_action_pressed("rotate_right"):
		direction_rotation += 1

	# DISPARO
	if Input.is_action_pressed("shot_main"):
		muzzle.set_is_shoting(true)
	if Input.is_action_just_released("shot_main"):
		muzzle.set_is_shoting(false)
