extends Panel

var COLOURS = {
  0: Color(0, 0, 0, 0),     # Means an empty tile.
  1: Color.html('69FF66'),  # Green.
  2: Color.html('66DAFF'),  # Blue.
  3: Color.html('D766FF'),  # Purple.
  4: Color.html('FFB966'),  # Yellow.
}


func set_colour(rarity: int) -> void:
  var stylebox = self.get_theme_stylebox('panel').duplicate()
  stylebox.bg_color = COLOURS[rarity]
  self.add_theme_stylebox_override('panel', stylebox)


func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/VBoxContainer/BodyText").text = for_text
  return tooltip  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.tooltip_text = "bingus"
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
