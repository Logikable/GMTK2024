extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  
  pass # Replace with function body.

  
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/VBoxContainer/BodyText").text = for_text
  return tooltip  
