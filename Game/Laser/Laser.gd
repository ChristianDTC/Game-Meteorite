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
