extends Node2D

var FALLING_SPEED = 300
var HORIZONTAL_SPEED = 0
var TIME = 0.0
var TIME_BETWEEN_MOVES = 0.4
var rng = RandomNumberGenerator.new()
var CAN_DIE = false
var CAN_MOVE = true

@onready var WW = get_node("/root/Main/WariableWarehouse")
@onready var players = get_tree().get_nodes_in_group("players")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HORIZONTAL_SPEED = rng.randf_range(-500, 500)
	$AnimatedSprite2D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CAN_MOVE:
		position.y += FALLING_SPEED * delta
		position.x += HORIZONTAL_SPEED * delta
	
	TIME += delta
	if TIME > TIME_BETWEEN_MOVES:
		HORIZONTAL_SPEED = rng.randf_range(-500, 500)
		TIME = 0.0
	
	
	if Input.is_action_just_pressed("ui_swap") and CAN_DIE == true:
		var ClosestPoint = Geometry2D.get_closest_point_to_segment(position, players[0].global_position, players[1].global_position)
		var distance = position.distance_to(ClosestPoint)
		if distance <= 65:
			WW.SCORE += 1
			WW.CAN_COMBO = true
			$AnimatedSprite2D.show()
			CAN_MOVE = false
			$AnimatedSprite2D.play()
			await get_tree().create_timer(0.1).timeout
			queue_free()
	
	CAN_DIE = WW.CAN_SWAP
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
