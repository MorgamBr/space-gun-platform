extends Area2D

var speed: float = 10.0
var damage: float = 1.0


func _physics_process(_delta: float) -> void:
	self.global_position += Vector2(speed, 0.0).rotated(rotation)


func _on_body_entered(_body: Node2D) -> void:
	self.queue_free()
