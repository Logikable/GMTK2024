extends Label

@export var grid : Node

# Grid size -> Font size.
const FONT_SIZES = {
  3: 30,
  4: 28,    # (unused)
  5: 26,
  6: 24,    # (unused)
  7: 22,
  8: 21,    # (unused)
  9: 20,
  10: 19,   # (unused)
  11: 18,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  grid.grid_size_updated.connect(_on_grid_size_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


# Change the position and size of the text.
func _on_grid_size_update(new_grid_size : int) -> void:
  var parent_center : Vector2 = Util.parent_center(self)
  # How much space we have above the grid.
  var y_space : int = parent_center.y - grid.size.y / 2
  # Make myself a bit bigger first.
  self.label_settings.font_size = FONT_SIZES[new_grid_size]
  # Update my position. This is relative to my size, so it must be done second.
  var my_size = self.size * self.scale
  self.position = Vector2(parent_center.x - my_size.x / 2, y_space / 2 - my_size.y / 2)
