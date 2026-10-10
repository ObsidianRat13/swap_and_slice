extends Node2D

@export var ENEMY_SCENE: PackedScene
@export var ENEMY_HOMING_RED_SCENE: PackedScene
@export var ENEMY_HOMING_BLUE_SCENE: PackedScene
@onready var RED = get_node("CharacterRed")
@onready var BLUE = get_node("CharacterBlue")
@onready var WW = get_node("WariableWarehouse")
@onready var UI = get_node("/root/UI")

var TIME = 0.0
var TIME_OF_SWAP = 0.0
var SWAP_COOLDOWN = 0.5
var MOVE_COOLDOWN = 0.2
var ENEMY_SPAWN_COOLDOWN = 2.0
var HOMING_ENEMY_SPAWN_COOLDOWN = 5.0
var ENEMY_TIMER = 0.0
var HOMING_ENEMY_TIMER = 0.0
var OLD_SCORE = 0
var COMBO_TIME = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score/GameOver.hide()
	$Tutorials.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Line2D.set_point_position(0, RED.global_position)
	$Line2D.set_point_position(1, BLUE.global_position)
	
	$Midpoint.global_position = RED.position.lerp(BLUE.position, 0.5)
	
	
	TIME += delta
	
	if TIME > 2:
		$Tutorials.hide()
	
	if Input.is_action_just_pressed("ui_swap") and WW.CAN_SWAP == true:
		swap()
		OLD_SCORE = WW.SCORE
		TIME_OF_SWAP = TIME
		if WW.CAN_COMBO == true:
			WW.SCORE += 5
			WW.CAN_COMBO = false
		
	if Input.is_action_just_pressed("ui_swap") and RED.position.distance_to(BLUE.position) < 400:
		$Midpoint/Animation.show()
		$Midpoint/Animation.play("TooClose")
	if Input.is_action_just_pressed("ui_swap") and RED.position.distance_to(BLUE.position) > 800:
		$Midpoint/Animation.show()
		$Midpoint/Animation.play("TooFar")
	
	if RED.position.distance_to(BLUE.position) > 400 and RED.position.distance_to(BLUE.position) < 800:
		$Line2D.default_color = Color("Black")
		if TIME - TIME_OF_SWAP  > SWAP_COOLDOWN and WW.CAN_SWAP == false:
			WW.CAN_SWAP = true
	else:
		$Line2D.default_color = Color("Red")
		WW.CAN_SWAP = false
		
		
		
	if TIME - TIME_OF_SWAP  > MOVE_COOLDOWN:
		RED.CAN_MOVE = true
		BLUE.CAN_MOVE = true
		
	ENEMY_TIMER += delta
	if ENEMY_TIMER > ENEMY_SPAWN_COOLDOWN:
		ENEMY_TIMER = 0
		spawn_enemy()
	
	HOMING_ENEMY_TIMER += delta
	if HOMING_ENEMY_TIMER > HOMING_ENEMY_SPAWN_COOLDOWN:
		HOMING_ENEMY_TIMER = 0
		spawn_homing_enemy()
	
	if WW.SCORE >= 10:
		ENEMY_SPAWN_COOLDOWN = 1.5
		HOMING_ENEMY_SPAWN_COOLDOWN = 4.0
	
	
		
	
	$Score/Label.text = "SCORE: %s" %WW.SCORE
###########

func spawn_enemy():
	var ENEMY = ENEMY_SCENE.instantiate()
	var ENEMY_SPAWN = $EnemySpawner/EnemySpawnerPath/EnemySpawnLocation
	ENEMY_SPAWN.progress_ratio = randf()
	ENEMY.position = ENEMY_SPAWN.position
	add_child(ENEMY)

func spawn_homing_enemy():
	var ENEMY = ENEMY_HOMING_RED_SCENE.instantiate()
	var ENEMY2 = ENEMY_HOMING_BLUE_SCENE.instantiate()
	var ENEMY_SPAWN = $EnemySpawner/EnemySpawnerPath/EnemySpawnLocation
	ENEMY_SPAWN.progress_ratio = randf()
	ENEMY.position = ENEMY_SPAWN.position
	ENEMY2.position = ENEMY_SPAWN.position
	if randf() < 0.5:
		add_child(ENEMY)
	else:
		add_child(ENEMY2)
	
func swap():
	OLD_SCORE = WW.SCORE
	var RPOS = RED.global_position
	var BPOS = BLUE.global_position
	#RED.global_position = BPOS
	#BLUE.global_position = RPOS
	var tweenR = create_tween()
	var tweenB = create_tween()
	tweenR.tween_property(RED,"position",BPOS,0.2)
	tweenB.tween_property(BLUE,"position",RPOS,0.2)
	WW.CAN_SWAP = false
	RED.CAN_MOVE = false
	BLUE.CAN_MOVE = false
	if randf() < 0.5:
		$Sounds/SwapSound.play()
	else:
		$Sounds/SwapSound2.play()
	
	
	
	
func game_over():
	$Score/GameOver.show()
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	queue_free()
	UI.show()
	get_tree().paused = false
	
	


func _on_character_red_died() -> void:
	game_over()
	
	
func _on_character_blue_died() -> void:
	game_over()


func _on_animation_animation_looped() -> void:
	$Midpoint/Animation.hide()
