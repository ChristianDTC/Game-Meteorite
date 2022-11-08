# ENEMIGO DUMMY
extends Node2D

var hit_points:float = 10.0

func _process(delta: float) ->void:
	$Muzzle.set_is_shoting(true) 

func take_damage(damage: float) -> void:
	hit_points -= damage
	if hit_points <= 0.0:
		queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.destroy()
