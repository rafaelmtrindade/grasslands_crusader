extends Node2D

signal spawn_enemy

export var tick_spawn_chance: int
export var spot_spawn_chance: int

# var Slime = preload("res://scenes/slime.tscn")
var is_dying: bool = false
var spawn_spots := []
var player_ref = null


func _ready():
	for spot in get_node("SpawnArea").get_children():
		if spot and !spot.disabled:
			spawn_spots.append(spot)


func _physics_process(_delta) -> void:
	animate()


func animate() -> void:
	if is_dying:
		$AnimationPlayer.play("death")
		set_physics_process(false)
	else:
		$AnimationPlayer.play("RESET")


func attempt_spawns():
	"""
	Seleciona N posições dentre as possíveis, aleatoriamente, para tentar
	spawnar inimigos.
	Tenta spawnar um inimigo uma vez para cada posição selecionada.
	Caso a tentativa tenha sucesso, emite um sinal "spawn_enemy".
	"""
	var amount: int = (randi() % spawn_spots.size()) + 1
	var spots := spawn_spots.duplicate().slice(0, amount)
	spots.shuffle()
	for s in spots:
		if randi() % 100 > spot_spawn_chance: continue
		emit_signal("spawn_enemy", s.global_position)


func _on_spawn_timer_tick():
	if tick_spawn_chance < randi() % 100: return
	attempt_spawns()

	
#func spawn_enemy(parent: Node2D, position: Vector2):
#	var slime = Slime.instance()
#	slime.global_position = position
#	parent.add_child(slime)

func _on_area_entered(area) -> void:
	if area.is_in_group("player_attack"):
		is_dying = true


func _on_animation_finished(anim_name) -> void:
	if anim_name == "death":
		queue_free()
