extends Control

@export var grid : Node

var cubies = 0

func cubies_per_second() -> int:
  var cps_per_tile : Array[int] = []
  return 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  grid.set_grid_size(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
