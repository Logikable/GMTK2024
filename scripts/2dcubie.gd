extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


var rng = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var stylebox = StyleBoxFlat.new()
  stylebox.bg_color = Color(rng.randf(), rng.randf(), rng.randf(), 1.0)
  add_theme_stylebox_override("panel", stylebox)
