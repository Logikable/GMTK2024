extends Panel

var rarity: int
var tooltips: Array = ["Generates 1 cubie/s",
                       "Doubles output of adjacent cubies",
                       "Increases cube output in a 3x3 area by 10%",
                       "Every 10 minutes, supercharges ALL cubes, doubling output"]

func set_colour(new_rarity: int) -> void:
  rarity = new_rarity
  var stylebox = self.get_theme_stylebox('panel').duplicate()
  stylebox.bg_color = Util.COLOURS[new_rarity]
  self.add_theme_stylebox_override('panel', stylebox)


func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/BodyText").text = for_text
  return tooltip  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.tooltip_text = Util.CUBIE_TOOLTIPS[rarity]
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
