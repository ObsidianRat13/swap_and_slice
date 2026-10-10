extends CharacterBody2D


var SPEED = 700
var CAN_MOVE = true
var DIRECTION = Vector2.ZERO
signal DIED

func _ready():
	add_to_group("players")

func _physics_process(delta: float) -> void:
	
	velocity = DIRECTION.normalized() * SPEED
	
	DIRECTION = Vector2.ZERO
	if CAN_MOVE == true:
		if Input.is_action_pressed("ui_red_up"):
			DIRECTION.y = -1
		if Input.is_action_pressed("ui_red_down"):
			DIRECTION.y = 1
		if Input.is_action_pressed("ui_red_left"):
			DIRECTION.x = -1
		if Input.is_action_pressed("ui_red_right"):
			DIRECTION.x = 1
		$CharacterRedHitbox.monitoring = true
	else:
		$CharacterRedHitbox.monitoring = false
	
	
	
	
	move_and_slide()


func _on_character_red_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "EnemyHitbox":
		DIED.emit()
	if area.name == "HomingEnemyHitbox":
		DIED.emit()
