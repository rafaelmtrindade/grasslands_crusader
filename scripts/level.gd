extends Node2D

var debug_mode: int = 0

func _ready() -> void:
	# inicializa o RNG global
	if debug_mode == 1:
		seed(10)
	else:
		randomize()
