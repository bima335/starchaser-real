extends Node

var stone1 = preload("res://Scenes/stone_1.tscn")
var stone2 = preload("res://Scenes/stone_2.tscn")
var stone_type := [stone1, stone2]
var stones : Array

const START_POS := Vector2i(150, 485)
const CAM_START := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var screen_size : Vector2i
var score : int
var game_running : bool
var SPEED_MOD : int= 4000
var last_st
var land_height : int

func _ready():
	screen_size = get_window().size
	land_height = $Land.get_node("Sprite2D").texture.get_height()
	new_game()
	
	
func new_game():
	game_running = false
	score = 0
	$Player.position = START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START
	$Land.position = Vector2i(0, 0)

func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MOD
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		#print(speed)
		
		generate_stones()
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		#print(score)
		if $Camera2D.position.x - $Land.position.x > screen_size.x * 1.5:
			$Land.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
func generate_stones():
	if stones.is_empty() or last_st.position.x < score + randi_range(300, 500):
		var st_type = stone_type[randi() % stone_type.size()]
		var st
		var max_st = 3
		for i in range(randi() % max_st + 1):
			st = st_type.instantiate()
			var st_height = st.get_node("Sprite2D").texture.get_height()
			var st_scale = st.get_node("Sprite2D").scale
			var st_x : int = screen_size.x + score + 100 + (i * 100)
			var st_y : int = screen_size.y - land_height - (st_height * st_scale.y / 2) + 5 
			last_st = st
			add_stones(st, st_x, st_y)

func add_stones(st, x, y):
	st.position = Vector2 (x,y)
	add_child(st)
	stones.append(st)
