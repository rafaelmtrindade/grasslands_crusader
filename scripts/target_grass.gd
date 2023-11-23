extends Node2D

onready var animation: AnimationPlayer = get_node("AnimationPlayer")
onready var sprite: Sprite = get_node("Sprite")

var player_ref = null
var is_dying = false


func _physics_process(_delta) -> void:
	animate()


func animate() -> void:
	if is_dying:
		animation.play("death")
		set_physics_process(false)
	else:
		animation.play("RESET")


func _on_area_entered(area) -> void:
	if area.is_in_group("player_attack"):
		is_dying = true


func _on_animation_finished(anim_name) -> void:
	if anim_name == "death":
		queue_free()
