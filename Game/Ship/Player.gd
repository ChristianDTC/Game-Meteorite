#JUGADOR
class_name Player
extends RigidBody2D

# ENUMERABLES
enum STATE {SPAWN, LIFE, INVENCIBLE, DEAD}

# ATRIBUTOS EXPORT
export var power_engine:int = 20 #potencia del motor
export var power_rotation:int = 280 #potencia de rotación
export var trail_max:int = 30 #estela máxima
export var hit_points:float = 15.0 # cantidad de vida

# ATRIBUTOS
var state_actual:int = STATE.SPAWN
var push:Vector2 = Vector2.ZERO
var direction_rotation:int = 0
var do_nothing = false


# ATRIBUTOS ONREADY
onready var muzzle:Muzzle = $Muzzle
onready var laser_beam:LaserBeam2D = $LaserBeam2D
onready var trail:Trail = $TrainPoint/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var collider:CollisionShape2D = $CollisionShape2D
onready var impact_sfx:AudioStreamPlayer = $ImpactSFX

# METODOS
func _ready() -> void:
	controller_state(state_actual)
	

func _unhandled_input(event: InputEvent) -> void:
	if not is_input_active():
		return
	
	#DISPARO RAYO
	if event.is_action_pressed("shot_secondary"):
		laser_beam.set_is_casting(true)
	if event.is_action_released("shot_secondary"):
		laser_beam.set_is_casting(false)
	
	#CONTROL ESTELA Y SONIDO
	if event.is_action_pressed("move_up"):
		trail.set_max_points(trail_max)
		motor_sfx.sound_off()
	elif event.is_action_pressed("move_down"):
		trail.set_max_points(0)
		motor_sfx.sound_off()
	if (event.is_action_released("move_up") or event.is_action_released("move_down")):
		motor_sfx.sound_on()


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(push.rotated(rotation))
	apply_torque_impulse(direction_rotation * power_rotation)

func _process(delta: float) -> void:
	player_input()


# METODOS CUSTOM
func controller_state(new_state: int) -> void:
	match new_state:
		STATE.SPAWN:
			collider.set_deferred("disabled", true)
			muzzle.set_can_shot(false)
		STATE.LIFE:
			collider.set_deferred("disabled", false)
			muzzle.set_can_shot(true)
		STATE.INVENCIBLE:
			collider.set_deferred("disabled", true)
		STATE.DEAD:
			collider.set_deferred("disabled", true)
			muzzle.set_can_shot(true)
			Events.emit_signal("ship_destroyed", global_position, 3)
			queue_free()
		_:
			printerr("Error de Estado")
	state_actual = new_state

func is_input_active() -> bool:
	if state_actual in [STATE.DEAD, STATE.SPAWN]:
		return false
	return true

func player_input() -> void:
	if not is_input_active():
		return
	
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

func destroy() -> void:
	controller_state(STATE.DEAD)

func take_damage(damage: float) -> void:
	hit_points -= damage
	if hit_points <= 0.0:
		destroy()
	impact_sfx.play()

#SEÑALES INTERNAS
func _on_AnimationPlayer_animation_finished(anim_name: String) ->void:
	if anim_name == "spawn":
		controller_state(STATE.LIFE)
