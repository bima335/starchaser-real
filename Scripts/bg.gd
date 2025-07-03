extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ui_layer = ParallaxLayer.new()
	ui_layer.motion_scale = Vector2(0, 0)  # Tidak bergerak dengan parallax
	$ParallaxBackground.add_child(ui_layer)

	var score_label = Label.new()
	score_label.text = "Score: 0"
	ui_layer.add_child(score_label)
