# PROYECTIL
class_name Laser
extends Area2D


# ATRIBUTOS
var velocity:Vector2 = Vector2.ZERO
var damage:float


# METODOS
func create(pos: Vector2, dir: float, vel:float, damage_p:int) -> void:
	position = pos
	rotation = dir
	velocity = Vector2(vel,0).rotated(dir)
	damage = damage_p

func _physics_process(delta: float) -> void:
	position += velocity * delta


# METODOS CUSTOM
func harm(other_body: CollisionObject2D) -> void: # dañar
	if other_body.has_method("take_damage"):
		other_body.take_damage(damage)
	queue_free()


# SEÑALES INTERNAS
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_Laser_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
	queue_free()

func _on_body_entered(body: Node) -> void:
	harm(body)

func _on_area_entered(area: Area2D) -> void:
	harm(area)

