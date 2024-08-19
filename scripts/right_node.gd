extends Control
var bg_cubie_scene: PackedScene = load("res://scenes/bg_cubies.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

# Creates background cubes
func _on_bg_cubie_spawn_timer_timeout() -> void:
  var bg_cubie = bg_cubie_scene.instantiate()
  add_child(bg_cubie)
  pass # Replace with function body.
