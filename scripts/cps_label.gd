extends Label

@export var grid: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  grid.grid_size_updated.connect(_on_grid_size_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_grid_size_update(new_grid_size: int) -> void:
  # Reveal cps label when we can start generating them.
  if new_grid_size > 1:
    self.visible = true
