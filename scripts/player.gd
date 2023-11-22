extends KinematicBody2D

export(int) var speed
export(int) var health
export(int) var damage

onready var animation: AnimationPlayer = get_node("AnimationPlayer")
onready var sprite: Sprite = get_node("Sprite")
onready var atk_collision: CollisionShape2D = get_node("AttackArea/Collision")

const RUN_PARTICLE: PackedScene = preload("res://scenes/player/run_particle.tscn")

var velocity: Vector2
var is_dying: bool = false
var can_attack: bool = true

func _physics_process(_delta) -> void:
	move()
	attack()
	animate()
	verify_direction()

func move() -> void:
	var dir: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = dir * speed
	velocity = move_and_slide(velocity)


func attack() -> void:
	if Input.is_action_just_pressed("ui_select") and can_attack:
		can_attack = false


func animate() -> void:
	if is_dying:
		animation.play("death")
		set_physics_process(false)
	elif !can_attack:
		animation.play("attack")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")


func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		atk_collision.position = Vector2(20, 8)
	elif velocity.x < 0:
		sprite.flip_h = true
		atk_collision.position = Vector2(-20, 8)


func instance_run_particle() -> void:
	var particle = RUN_PARTICLE.instance()
	get_tree().root.call_deferred("add_child", particle)
	particle.global_position = global_position + Vector2(0, 16)
	particle.play_particle()


# todo
func take_damage(amount) -> void:
	# todo: 
	#	checar se o jogador pode tomar dano (cooldown)
	health -= amount
	if health <= 0: kill()


func kill() -> void:
	is_dying = true


func _on_animation_finished(anim_name):
	if anim_name == "death":
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "attack":
		set_physics_process(true)
		can_attack = true
