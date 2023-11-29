extends Node2D

var debug_mode: int = 0

var Slime = preload("res://scenes/slime.tscn")

func _process(_delta):
	if $YSort.get_child_count() == 32:
		$GameOverLabel.text = "You win!"
		$GameOverLabel.rect_position = $YSort/Player/Camera2D.get_camera_screen_center()
		$GameOverLabel.percent_visible = 1
		$YSort/Player.set_physics_process(false)
		
func _ready() -> void:
	# inicializa o RNG global
	randomize() if debug_mode != 1 else seed(10)
	
	for i in range(1, 107+1, 3):
		var spawner := get_node("YSort/TargetGrass" + str(i))
		if !spawner: continue # safe-guard
		spawner.connect("spawn_enemy", self, "_on_spawn_enemy")


func _on_spawn_enemy(position):
	var distance: Vector2 = $YSort/Player.global_position - position
	if distance.length() < 50: return
	var slime = Slime.instance()
	slime.global_position = position
	$YSort.add_child(slime)
