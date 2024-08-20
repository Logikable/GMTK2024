extends Button

# I do this so we can call this script when generating nodes
# through code

var Tooltip: PackedScene = load("res://scenes/tooltip.tscn")


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
