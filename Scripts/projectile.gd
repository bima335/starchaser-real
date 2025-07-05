extends Area2D

var base_y: float
var range : float = 50
var speed: float = 3
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_y = position.y
	range = randf_range(20,80)
	speed = randf_range(2.5, 3.5)

func _physics_process(delta):
	time += delta
	
	position.y = base_y + sin(time * speed) * range

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_area_entered(area: Area2D) -> void:
	if area.name == "Barrier":
		visible = false
		set_process_mode(Node.PROCESS_MODE_DISABLED)
		
		if find_child("CollisionPolygon2D"):
			find_child("CollisionPolygon2D").disabled = true
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
