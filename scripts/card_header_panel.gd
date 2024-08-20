extends Panel

@export var Tooltip: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _make_custom_tooltip(for_text: String) -> Node:
  var tooltip = Tooltip.instantiate()
  tooltip.set_text(for_text)
  return tooltip
