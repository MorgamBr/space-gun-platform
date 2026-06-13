extends CharacterBody2D
class_name Player

const BULLET = preload("res://nodes/player/guns/bullet.tscn")
const LASER = preload("res://nodes/player/guns/laser.tscn")

const NORMAL_SPEED = 300.0
var speed: float = NORMAL_SPEED
var added_declining_x_speed: float = 0.0
const NORMAL_JUMP_VELOCITY = -400.0
const jump_velocity: float = NORMAL_JUMP_VELOCITY

@export var bullet_damage: float = 1.0
@export var gun_pointer: Node2D
@export var bullet_pos: Node2D
@export var laser_raycast: RayCast2D
const RIFLE_SHOT_COOLDOWN_TIME: float = 0.3
var rifle_shot_cooldown: float = 0.0
const LASER_SHOT_COOLDOWN_TIME: float = 0.8
var laser_shot_cooldown: float = 0.0

@export var camera: Camera2D


func _ready() -> void:
	Global.player = self


func _process(delta: float) -> void:
	gun_pointer.look_at(get_global_mouse_position())
	
	rifle_shot_cooldown = max(rifle_shot_cooldown - delta, 0.0)
	laser_shot_cooldown = max(laser_shot_cooldown - delta, 0.0)
	
	if Input.is_action_pressed("shoot_rifle") and rifle_shot_cooldown == 0.0:
		shoot_rifle()
	
	if Input.is_action_pressed("shoot_laser") and laser_shot_cooldown == 0.0:
		shoot_laser()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	added_declining_x_speed = lerpf(added_declining_x_speed, 0.0, 0.2)
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = lerpf(velocity.x, (direction * speed) + added_declining_x_speed, 0.4)
	else:
		velocity.x = move_toward(velocity.x, 0, 25.0)
	
	move_and_slide()


func shoot_rifle() -> void:
	rifle_shot_cooldown = RIFLE_SHOT_COOLDOWN_TIME
	instantiate_bullet()


func instantiate_bullet() -> void:
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_rotation = gun_pointer.global_rotation
	bullet_instance.global_position = bullet_pos.global_position
	bullet_instance.damage = bullet_damage
	get_tree().current_scene.add_child(bullet_instance)


func shoot_laser() -> void:
	laser_shot_cooldown = LASER_SHOT_COOLDOWN_TIME
	instantiate_laser()
	push(100, Vector2(-1.0, 0.0).rotated(gun_pointer.rotation))


func instantiate_laser() -> void:
	var laser_instance = LASER.instantiate()
	laser_instance.rotation = gun_pointer.global_rotation
	laser_instance.position = bullet_pos.global_position
	if laser_raycast.is_colliding():
		laser_instance.is_colliding = laser_raycast.is_colliding()
		laser_instance.collision_point = laser_raycast.get_collision_point()
	get_tree().current_scene.add_child(laser_instance)


func push(amount: float, direction: Vector2) -> void:
	var added_velocity: Vector2 = Vector2(direction.x * amount * 5.0, direction.y * amount * 5.0)
	velocity += added_velocity
	added_declining_x_speed += added_velocity.x
