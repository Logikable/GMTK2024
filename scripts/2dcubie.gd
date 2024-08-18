extends Panel

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var stylebox = self.get_theme_stylebox('panel').duplicate()
  stylebox.bg_color = Color(rng.randf(), rng.randf(), rng.randf(), 1.0)
  self.add_theme_stylebox_override('panel', stylebox)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
