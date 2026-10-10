extends Node

var CAN_SWAP = true
var SCORE = 0
var CAN_COMBO = false
var JUST_COMBOED = false
var TIME = 0.0
var COMBO_COOLDOWN = 1
var TIME_OF_COMBO = 0.0
@onready var COMBO = get_node("/root/Main/Score/COMBO")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if JUST_COMBOED and CAN_COMBO:
		SCORE += 5
		TIME = 0.0
		CAN_COMBO = false
		COMBO.show()
		await get_tree().create_timer(0.5).timeout
		COMBO.hide()
		
	
	if JUST_COMBOED and TIME < COMBO_COOLDOWN:
		TIME += delta
	if TIME > COMBO_COOLDOWN:
		TIME = 0.0
		JUST_COMBOED = false
	
	if CAN_COMBO:
		JUST_COMBOED = true
		CAN_COMBO = false
		TIME_OF_COMBO = TIME
	
	
		
