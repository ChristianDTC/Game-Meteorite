# AREA DE COLISION
extends Area2D

func take_damage(damage: float):
	owner.take_damage(damage)
