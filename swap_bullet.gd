extends Node2D

var BLUEPOS = Vector2.ZERO
var DIRECTION = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DIRECTION = BLUEPOS - position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += DIRECTION*delta*10


func _on_swap_bullet_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "CharacterRedHitbox":
		queue_free()
	if area.name == "CharacterBlueHitbox":
		queue_free()
	
