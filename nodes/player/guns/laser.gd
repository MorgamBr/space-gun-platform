extends Area2D

@export var collision_shape: CollisionShape2D
@export var sprite: ColorRect
var is_colliding: bool = false
var collision_point: Vector2 = Vector2.ZERO

const LASER_DURATION: float = 0.15
var laser_time_remaining: float = LASER_DURATION

var already_hit_targets: Array[Node2D] = []


func _ready() -> void:
	if is_colliding:
		var collision_distance: float = self.global_position.distance_to(collision_point)
		collision_shape.shape.size.x = collision_distance
		collision_shape.position.x = collision_distance / 2.0
		sprite.size.x = collision_distance + 15.0
	else:
		collision_shape.shape.size.x = 1200
		collision_shape.position.x = 600
		sprite.size.x = 1200


func _process(delta: float) -> void:
	laser_time_remaining -= delta
	
	sprite.color.a = laser_time_remaining / LASER_DURATION
	
	if laser_time_remaining <= 0.0:
		self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	already_hit_targets.append(body)
