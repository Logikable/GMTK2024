extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


var rng = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  add_theme_color_override("font_color", Color.YELLOW)
  #self.add_theme_color_override("local_color", Color(rng.randf(), rng.randf(), rng.randf(), 1.0))
