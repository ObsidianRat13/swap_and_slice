extends CharacterBody2D


var SPEED = 700
var CAN_MOVE = true
signal DIED

var DIRECTION = Vector2.ZERO

func _ready():
	add_to_group("players")

func _physics_process(_delta: float) -> void:
	
	velocity = DIRECTION.normalized() * SPEED
	
	DIRECTION = Vector2.ZERO
	if CAN_MOVE == true:
		
		if Input.is_action_pressed("ui_blue_up"):
			DIRECTION.y = -1
		if Input.is_action_pressed("ui_blue_down"):
			DIRECTION.y = 1
		if Input.is_action_pressed("ui_blue_left"):
			DIRECTION.x = -1
		if Input.is_action_pressed("ui_blue_right"):
			DIRECTION.x = 1
		$CharacterBlueHitbox.monitoring = true
	else:
		$CharacterBlueHitbox.monitoring = false
	
	
	
	
	move_and_slide()


func _on_character_blue_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "EnemyHitbox":
		DIED.emit()
	if area.name == "HomingEnemy2Hitbox":
		DIED.emit()
