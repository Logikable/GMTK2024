extends Control


# Set the scale of this instance of Tile to be `pixels` wide.
func update_scale(pixels: int) -> void:
  assert(self.size.x == self.size.y)
  var scene_width = self.size.x
  var new_scale_scalar = pixels / scene_width
  self.scale = Vector2(new_scale_scalar, new_scale_scalar)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
