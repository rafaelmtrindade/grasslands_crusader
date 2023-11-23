extends KinematicBody2D

export(int) var speed
export(int) var health
export(int) var damage

onready var animation: AnimationPlayer = get_node("AnimationPlayer")
onready var sprite: Sprite = get_node("Sprite")

var velocity: Vector2
var player_ref = null
var is_dying = false


func _physics_process(_delta) -> void:
	move()
	animate()
	verify_direction()
	

func move() -> void:
	var vel: Vector2 = Vector2.ZERO
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		var dist_len: float = distance.length()
		if dist_len > 5:
			vel = speed * direction
		else:
			# todo: refatorar (Insta kill -> DPS)
			# player_ref.take_damage(damage)
			player_ref.kill()
	velocity = move_and_slide(vel)


func animate() -> void:
	if is_dying:
		animation.play("death")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")


func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		player_ref = body


func _on_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_ref = null


func kill(area) -> void:
	if area.is_in_group("player_attack"):
		is_dying = true


func _on_animation_finished(anim_name) -> void:
	if anim_name == "death":
		queue_free()
