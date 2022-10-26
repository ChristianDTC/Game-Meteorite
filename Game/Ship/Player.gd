class_name Player
extends RigidBody2D


# Atributos Export
export var power_engine:int = 20 #potencia del motor
export var power_rotation:int = 280 #potencia de rotación


# Atributos
var push:Vector2 = Vector2.ZERO
var direction_rotation:int = 0


# Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_torque_impulse(direction_rotation * power_rotation)

func _process(delta: float) -> void:
	player_input()

# Metodos Custom
func player_input() -> void:
	# Empuje
	push = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		push = Vector2(power_engine, 0)
	elif Input.is_action_pressed("move_down"):
		push = Vector2(-power_engine, 0)

	# Rotación
	direction_rotation = 0
	if Input.is_action_pressed("rotate_left"):
		direction_rotation -= 1
	elif Input.is_action_pressed("rotate_right"):
		direction_rotation += 1
