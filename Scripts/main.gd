extends Node

var stone1 = preload("res://Scenes/stone_1.tscn")
var stone2 = preload("res://Scenes/stone_2.tscn")
var projectile = preload("res://Scenes/projectile.tscn")

var barrier_scene = preload("res://Scenes/barrier.tscn")
var current_barrier = null
var player = null


var stone_type := [stone1, stone2]
var stones : Array

var can_barrier = true

var projectile_height := [200, 400 ]

const START_POS := Vector2i(150, 485)
const CAM_START := Vector2i(576, 324)
const MOON_START := Vector2i(698, 330)

var generate = true

var difficulty
const MAX_DIFFICULTY : int = 2

var spawned_enemy = false

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 16
var screen_size : Vector2i

var score : int
var high_score: int

var game_running : bool
var SPEED_MOD : int= 5000
var last_st
var land_height : int

func _ready():
	screen_size = get_window().size
	land_height = $Land.get_node("Sprite2D").texture.get_height()
	$BG.get_node("Control3/Restart").pressed.connect(new_game)
	player = $Player
	
	
	if not player:
		push_error("Player 404")
		return
	new_game()
	#$Player/Barrier.hide()
	
func new_game():
	game_running = false
	score = 0
	get_tree().paused = false
	difficulty = 0
	$"BG".get_node("Control/LabelScore").text = "SCORE: 0"
	$BG/Control4/Start.show()
	
#	CLEAN
	#for st in stones:
		#st.queue_free()
	#stones.clear()
	
	$Player.position = START_POS
	#$Barrier.position = START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START
	$BG/Moon.position = MOON_START
	$Land.position = Vector2i(0, 0)
	$BG/Control3/Restart.hide()

func _input(event):
	if event.is_action_pressed("barrier"):
		toggle_barrier()
		
func toggle_barrier():
	if current_barrier:
		current_barrier.queue_free()
		current_barrier = null
	else:
		current_barrier = barrier_scene.instantiate()
		player.add_child(current_barrier)
		current_barrier.position = Vector2.ZERO
		current_barrier.set_as_top_level(false)
		
		var timer = get_tree().create_timer(0.3)
		timer.timeout.connect(barrier_time)

func barrier_time():
	if current_barrier:
		current_barrier.queue_free()
		current_barrier = null 

func _process(delta):
	if game_running:
		if speed < MAX_SPEED:
			speed = START_SPEED + score / SPEED_MOD
		adjust_difficulty()
		
		$BG/Control4/Start.hide()
		
		if generate:
			generate_stones()
		$Player.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		show_score()
		#print(score/10)
		#print(speed)
		#print(difficulty)
		
		if $BG/Moon.position.y > 80:
			$BG/Moon.position.y -= speed/10
#			Stage change
		#else:
			#generate = false
			#var tween = create_tween()
			#tween.set_parallel(true)
			#tween.tween_property($BG/Moon, "scale", Vector2.ZERO, 2.0)
			#tween.tween_property($BG/ParallaxLayer/Sprite2D, "modulate", Color.BLACK, 2.0)
			#tween.tween_property($BG/ParallaxLayer2/Sprite2D, "modulate", Color.BLACK, 2.0)
			

		if $Camera2D.position.x - $Land.position.x > screen_size.x * 1.5:
			$Land.position.x += screen_size.x
		
#		CLEAN
		#for st in stones:
			#if st.position.x < ($Camera2D.position.x - screen_size.x):
				#remove_stones(st)
		#
		#if Input.is_action_just_pressed("barrier"):
			#if can_barrier:
				#place_barrier()
				#can_barrier = false
		
	else:
		if Input.is_action_pressed("jump"):
			game_running = true



func generate_stones():
	if stones.is_empty() or last_st.position.x < score + randi_range(300, 500):
		var st_type = stone_type[randi() % stone_type.size()]
		var st
		var max_st = difficulty + 1
		for i in range(randi() % max_st + 1):
			st = st_type.instantiate()
			var st_height = st.get_node("Sprite2D").texture.get_height()
			var st_scale = st.get_node("Sprite2D").scale
			var st_x : int = screen_size.x + score + 100 + (i * 100)
			var st_y : int = screen_size.y - land_height - (st_height * st_scale.y / 2) + 5 
			last_st = st
			add_stones(st, st_x, st_y)
			
		if(randi() % 2) == 0:
			st = projectile.instantiate()
			var st_x : int = screen_size.x + score + 100
			var st_y : int = projectile_height[randi() % projectile_height.size()]
			add_projectile(st, st_x, st_y)

func add_stones(st, x, y):
	st.position = Vector2 (x,y)
	st.body_entered.connect(hit_stone)
	add_child(st)
	stones.append(st)

func add_projectile(st, x, y):
	st.position = Vector2 (x,y)
	st.body_entered.connect(hit_stone)
	add_child(st)
	stones.append(st)

func remove_stones(st):
	st.queue_free()
	stones.erase(st)
	
func hit_stone(body):
	if body.name == "Player":
		game_over()  


func show_score():
	$"BG".get_node("Control/LabelScore").text = "SCORE: " + str(score/10)
	
func get_high_score():
	if score > high_score:
		high_score = score
		$"BG".get_node("Control2/LabelHigh").text = "HIGH SCORE: " + str(high_score / 10)

func adjust_difficulty():
	difficulty = score / SPEED_MOD
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	get_high_score()
	get_tree().paused = true
	game_running = false
	$BG/Control3/Restart.show()
	print(speed)
