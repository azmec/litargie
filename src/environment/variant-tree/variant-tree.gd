class_name VariantTree
extends Node2D

export var set_variant: bool = false
export var variant: int = 0

onready var sprite: = $Sprite 

func _ready() -> void:
	randomize() 

	if set_variant:
		sprite.frame = variant
	else:
		sprite.frame = get_random_frame()

func get_random_frame() -> int:
	var possible_variants: int = sprite.hframes
	var res: = randi() % possible_variants

	return res
