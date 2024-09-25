extends Node2D

@export var position_base = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if position_base != Vector2(0,0) :
		$Trigger.position = position_base


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

	


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if (body.has_method("_die")):
		body._die()
